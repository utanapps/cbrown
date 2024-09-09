import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/providers/auth_state_provider.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/components/custom_text_field.dart';
import 'package:baseapp/components/rounded_close_button.dart';
import 'package:baseapp/components/custom_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:baseapp/components/language_dropdown.dart';
import 'package:baseapp/utils/validators.dart';
import '../components/custom_show_dialog.dart';

class PasswordRecoveryPage extends ConsumerStatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  PasswordRecoveryPageState createState() => PasswordRecoveryPageState();
}

class PasswordRecoveryPageState extends ConsumerState<PasswordRecoveryPage> {
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数

  @override
  void initState() {
    super.initState();
    supabaseService =
        ref.read(supabaseServiceProvider); // SupabaseServiceを一度だけ取得
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _recoverPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true); // ローディング開始

    try {
      await supabaseService.updateUserPassword(
        newPassword: _newPasswordController.text,
      );
      ref.read(statusProvider.notifier).updateStatus(AuthStatus.authenticated);

      if (mounted) {
        showCustomDialog(
          context: context,
          title: S.of(context).successLabel,
          message: S.of(context).successChangePassword,
        );
      }

      // if (mounted) {
      //   showCustomDialog(
      //     context: context,
      //     title: S.of(context).successLabel,
      //     message: S.of(context).successChangePassword,
      //   );
      // }
    } catch (e) {
      if (e is Exception) {
        String message = e.toString();
        if (message.contains(
            'New password should be different from the old password')) {
          if (mounted) {
            showCustomDialog(
              context: context,
              title: S.of(context).errorLabel,
              message: S.of(context).newPasswordMustBeDifferent,
            );
          }
        } else {
          if (mounted) {
            showCustomDialog(
              context: context,
              title: S.of(context).errorLabel,
              message: S.of(context).error,
            );
          }
        }
      }
    } finally {
      setState(() => _isLoading = false); // ローディング終了
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedCloseButton(),
        actions: const [
          LanguageDropdown(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  PhosphorIcons.shieldPlus(),
                  size: 70.0, // Set the size of the icon to 50 logical pixels
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    S.of(context).passwordRecoveryPageTitle,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
                Text(S.of(context).passwordRecoveryPageDescription),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: _newPasswordController,
                        label: S.of(context).newPassword,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        validator: (value) {
                          return validatePassword(
                            value,
                            S.of(context).enterPassword,
                            S.of(context).passwordTooShort,
                            S.of(context).passwordNeedsUppercase,
                            S.of(context).passwordNeedsLowercase,
                            S.of(context).passwordNeedsNumber,
                            S.of(context).passwordNeedsSpecialCharacter,
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: S.of(context).changePassword,
                              onPressed: () => _recoverPassword(),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
