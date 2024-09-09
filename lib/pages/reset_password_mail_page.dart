import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/components/custom_snack_bar.dart';
import 'package:baseapp/utils/constants.dart';
import 'package:baseapp/components/custom_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:baseapp/components/custom_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:baseapp/components/custom_app_bar.dart';
import 'package:baseapp/components/custum_dialog.dart';
import 'package:baseapp/utils/validators.dart';

import '../components/custom_show_dialog.dart';

class ResetPasswordMailPage extends ConsumerStatefulWidget {
  const ResetPasswordMailPage({super.key});

  @override
  ResetPasswordMailPageState createState() => ResetPasswordMailPageState();
}

class ResetPasswordMailPageState extends ConsumerState<ResetPasswordMailPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text;
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // ローディング開始

      try {
        // await supabaseService.resetPasswordForEmail(email,
        //     redirectTo: kIsWeb
        //         ? 'https://utanapps.vercel.app/reset-password'
        //         : 'io.supabase.baseapp://reset-password');
        await supabaseService.resetPasswordForEmail(email,
            redirectTo: 'https://questutan-utanapps-projects.vercel.app');
        if (mounted) {
          showCustomDialog(
            context: context,
            title: S.of(context).successLabel,
            message: S.of(context).passwordRecoveryMessage,
            onOkPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
          );
        }
      } catch (e) {
        if (mounted) {
          showCustomDialog(
            context: context,
            title: S.of(context).errorLabel,
            message: S.of(context).error,
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showCloseButton: true,
      ), // カスタムAppBarを使用
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: boxWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.wrench(),
                    size: 70.0, // Set the size of the icon to 50 logical pixels
// Pencil Icon
                  ),
                  const SizedBox(height: 40),
                  Text(
                    S.of(context).passwordRecoveryPageTitle,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  Text(S.of(context).passwordRecoveryPageDescription),
                  const SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          label: S.of(context).email,
                          keyboardType: TextInputType.emailAddress,
                          fontSize: baseFontSize,
                          validator: (value) {
                            return validateEmail(
                              value,
                              S.of(context).invalidEmailFormat,
                              S.of(context).enterEmail,
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: S.of(context).btnResetPassword,
                                onPressed: () => _resetPassword(),
                              ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(S.of(context).back,
                              style: const TextStyle(fontSize: baseFontSize)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
