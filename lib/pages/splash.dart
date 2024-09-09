import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/providers/auth_state_provider.dart';
import 'package:baseapp/pages/home.dart';
import 'package:baseapp/pages/welcome.dart';
import 'package:baseapp/pages/login.dart';
import 'package:baseapp/pages/password_recovery_page.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(statusProvider);
    Widget landingPage;
    print('333333');

    switch (authStatus) {
      case AuthStatus.authenticated:
        landingPage = const HomePage();
        break;
      case AuthStatus.passwordRecovery:
        landingPage = const PasswordRecoveryPage();
        break;
      case AuthStatus.unauthenticated:
        landingPage = const WelcomePage();
        break;
      case AuthStatus.unconfirmed: // unconfirmed と unauthenticated で同じページを表示
        landingPage = const LoginPage();
        break;
      default:
        landingPage = const WelcomePage();
        break;
    }

    // スプラッシュ画面のUIを表示
    return Scaffold(
      body: landingPage,
    );
  }
}
