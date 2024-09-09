import 'package:baseapp/components/custom_show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/providers/auth_state_provider.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/components/language_dropdown.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/components/custom_text_field.dart';
import 'package:baseapp/components/custom_snack_bar.dart';
import 'package:baseapp/components/rounded_close_button.dart';
import 'package:baseapp/components/custom_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:baseapp/providers/locale_providers.dart';
import 'package:baseapp/utils/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangeEmailPage extends ConsumerStatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  ChangeEmailPageState createState() => ChangeEmailPageState();
}

class ChangeEmailPageState extends ConsumerState<ChangeEmailPage> {
  final _newEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late final SupabaseService supabaseService;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    supabaseService = ref.read(supabaseServiceProvider);
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    super.dispose();
  }

  Future<void> _changeEmail(locale) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await supabaseService.updateUserEmail(
          newEmail: _newEmailController.text,
          languageCode: locale.languageCode.toString());

      ref.read(statusProvider.notifier).updateStatus(AuthStatus.authenticated);
      if (mounted)
        CustomSnackBar.show(ScaffoldMessenger.of(context),
            S.of(context).emailChangeVerificationMessage);
    } catch (e) {
      if (e is AuthException) {
        if (e.message.contains(
            'A user with this email address has already been registered')) {
          if (mounted)
            errorMessage = S.of(context).userAlreadyRegisteredMessage;
          //net work error
        } else if (e.message.contains('AuthRetryableFetchError')) {
          if (mounted) errorMessage = S.of(context).networkErrorMessage;
        }
      } else {
        if (mounted) errorMessage = S.of(context).error;
      }
      if (mounted) {
        showCustomDialog(
            title: S.of(context).errorLabel,
            message: S.of(context).error,
            context: context);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedCloseButton(),
        actions: const [
          LanguageDropdown(),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  PhosphorIcons.envelopeSimpleOpen(),
                  size: 70.0,
                ),
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    S.of(context).changeEmailPageTitle,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: _newEmailController,
                        label: S.of(context).newEmail,
                        keyboardType: TextInputType.emailAddress,
                        isPassword: false,
                        validator: (value) {
                          return validateEmail(
                            value,
                            S.of(context).invalidEmailFormat,
                            S.of(context).enterEmail,
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomButton(
                              text: S.of(context).changeEmail,
                              onPressed: () => _changeEmail(locale),
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
