import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/components/custom_text_field.dart';
import 'package:baseapp/utils/constants.dart';
import 'package:baseapp/components/custom_snack_bar.dart';
import 'package:baseapp/components/custom_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:baseapp/components/custom_app_bar.dart';
import 'package:baseapp/providers/locale_providers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:baseapp/utils/validators.dart';

import '../components/custom_show_dialog.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends ConsumerState<SignUpPage> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数
  bool _isUsernameAvailable = true; // ユーザー名の利用可能状態を追跡
  // String? _usernameError;
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

  Future<void> _signUp(locale) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true); // ローディング開始

    final username = _userNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    // String redirectUrl = kIsWeb
    //     ? "https://utanapps.vercel.app/signup"
    //     : "io.supabase.baseapp://signup";

    String redirectUrl = "https://questutan-utanapps-projects.vercel.app";


    try {
      await supabaseService.signUp(
          username: username,
          email: email,
          password: password,
          redirectTo: redirectUrl,
          msg: S.of(context).firstChatMessage,
          languageCode: locale.languageCode.toString());

      if (mounted) {
        showCustomDialog(
          context: context,
          title: S.of(context).successLabel,
          message: S.of(context).verifyEmail,
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
      setState(() => _isLoading = false); // ローディング終了
    }
  }

  void _checkUsernameAvailability() async {
    final username = _userNameController.text.trim();

    if (username.isEmpty) {
      setState(() {
        _isUsernameAvailable = false;
        // _usernameError = S.of(context).fieldRequired;
      });
      return;
    }

    if (username.length < 2) {
      setState(() {
        _isUsernameAvailable = false;
        // _usernameError = S.of(context).usernameTooShort;
      });
      return;
    }

    // 2文字以上の場合のみリモートチェックを行う
    try {
      final isAvailable =
          await supabaseService.checkUsernameAvailability(username: username);
      setState(() {
        _isUsernameAvailable = isAvailable;
        // _usernameError = isAvailable ? null : S.of(context).usernameAlreadyTaken;
      });
    } catch (e) {
      setState(() {
        _isUsernameAvailable = false;
        // _usernameError = S.of(context).error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    return Scaffold(
      appBar: const CustomAppBar(
        showCloseButton: true,
      ), // カスタムAppBarを使用

      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: boxWidth),
              child: Column(
                children: [
                  Icon(
                    PhosphorIcons.shieldCheck(),
                    size: 70.0, // Set the size of the icon to 50 logical pixels
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextField(
                          decoration: InputDecoration(
                            labelText: S.of(context).username,
                            suffixIcon: _isUsernameAvailable
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.error, color: Colors.red),
                          ),
                          controller: _userNameController,
                          label: S.of(context).firstName,
                          onChanged: (value) {
                            _checkUsernameAvailability();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).fieldRequired;
                            }
                            if (value.length < 2) {
                              return S.of(context).usernameTooShort;
                            }
                            if (!_isUsernameAvailable) {
                              return S.of(context).usernameAlreadyTaken;
                            }
                            return null;
                          },
                        ),
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
                        CustomTextField(
                          controller: _passwordController,
                          label: S.of(context).password,
                          keyboardType: TextInputType.visiblePassword,
                          isPassword: true,
                          fontSize: baseFontSize,
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
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: S.of(context).signUp,
                                onPressed: () => _signUp(locale),
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
