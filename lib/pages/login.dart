import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/pages/signup.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/components/custom_snack_bar.dart';
import 'package:baseapp/utils/constants.dart';
import 'package:baseapp/components/custom_text_field.dart';
import 'package:baseapp/pages/reset_password_mail_page.dart';
import 'package:baseapp/components/custom_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:baseapp/providers/auth_state_provider.dart';
import 'package:baseapp/components/custum_dialog.dart';
import 'package:baseapp/providers/check_version.dart';
import 'package:baseapp/utils/validators.dart';
import 'package:flutter/foundation.dart'; // kReleaseModeをインポート

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final bool _showResendVerificationEmailButton = false; // 追加: ボタン表示フラグ
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数
  String statusMessage = "";

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

  Future<void> _resendVerificationEmail() async {
    try {
      await supabaseService.resendVerificationEmail(_emailController.text);
      if (mounted)
        CustomSnackBar.show(ScaffoldMessenger.of(context),
            S.of(context).verificationEmailResent);
    } catch (e) {
      if (mounted)
        CustomSnackBar.show(
            ScaffoldMessenger.of(context), S.of(context).resendEmailError);
    }
  }

  Future<void> _signIn() async {
    print('hikaos');
    if (!_formKey.currentState!.validate()) {
      return; // フォームが有効でなければ早期リターン
    }
    setState(() => _isLoading = true); // ローディング開始

    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await supabaseService.signInWithPassword(email, password);

      final user = supabaseService.getCurrentUser();
      await supabaseService.setUserToProvider(user!.id, ref);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      print(e);
      if (e is Exception) {
        String message = e.toString();
        if (message.contains('100')) {
          if (mounted) {
            // 直接アクションシートを表示する
            _showResendEmailActionSheet(context); // contextを引数に渡す
          }
        } else if (message.contains('200')) {
          if (mounted) {
            CustomAlertDialog.show(context,
                message: S.of(context).loginErrorMessage,
                backgroundColor: Colors.red);
          }
        } else {
          if (mounted)
            CustomSnackBar.show(
                ScaffoldMessenger.of(context), S.of(context).error);
        }
      } else {
        // Exception以外のエラーに対する処理をここに記述
        if (mounted)
          CustomSnackBar.show(
              ScaffoldMessenger.of(context), S.of(context).error);
      }
    } finally {
      setState(() => _isLoading = false); // ローディング終了
    }
  }

  // メール再送を促すCupertinoActionSheetを表示するメソッド
  void _showResendEmailActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          S.of(context).verificationEmailNotReceived,
          style: const TextStyle(fontSize: 20),
        ),
        message: Text(
          S.of(context).wouldYouLikeToResendEmail,
          style: const TextStyle(fontSize: 20),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(
              S.of(context).resend,
              style: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
              try {
                _resendVerificationEmail(); // メール再送処理を呼び出す
                CustomSnackBar.show(ScaffoldMessenger.of(context),
                    S.of(context).verificationEmailResent);
              } catch (e) {
                CustomSnackBar.show(ScaffoldMessenger.of(context),
                    S.of(context).resendEmailError);
              } // ActionSheetを閉じる
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            S.of(context).cancel,
            style: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context); // ActionSheetを閉じる
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(statusProvider); // 現在の認証状態を取得
    // String statusMessage;
    switch (authStatus) {
      case AuthStatus.authenticated:
        statusMessage = "ログイン済み";
        break;
      case AuthStatus.unauthenticated:
        statusMessage = "未ログイン";
        break;
      case AuthStatus.unconfirmed:
        statusMessage = "メール確認待ち";
        break;
      case AuthStatus.passwordRecovery:
        statusMessage = "パスワード回復中";
        break;
      case AuthStatus.error:
        statusMessage = "error";
        break;
      default:
        statusMessage = "不明な状態";
    }
    return Scaffold(
      // backgroundColor: const Color(0xffB1D4E5),
      // appBar: const CustomAppBar(), // カスタムAppBarを使用
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: boxWidth), // 最大幅を設定
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!kReleaseMode) // Display only in test environment
                    const Text(
                      'Test Environment',
                      style: TextStyle(fontSize: 16.0),
                    ),                  const VersionCheckComponent(),
                  // Text("status:${statusMessage}"),
                  Icon(
                    PhosphorIcons.lockKey(),
                    size: 70.0,
                  ),
                  const SizedBox(height: 40),
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
                          maxLength: 254,
                          // 最大文字数を設定
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
                          maxLength: 254,
                          // 最大文字数を設定
                          fontSize: baseFontSize,
                          validator: (value) {
                            return validateSimplePassword(
                              value,
                              S.of(context).enterPassword,
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: S.of(context).signIn,
                                onPressed: () => _signIn(),
                              ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()),
                              );
                            },
                            child: Text(S.of(context).signUp,
                                style: const TextStyle(fontSize: 18))),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPasswordMailPage()),
                              );
                            },
                            child: Text(S.of(context).forgotPassword,
                                style: const TextStyle(fontSize: 18))),
                        if (_showResendVerificationEmailButton)
                          TextButton(
                            onPressed: _resendVerificationEmail,
                            child: Text(S.of(context).resendVerificationEmail),
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
