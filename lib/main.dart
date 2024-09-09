import 'package:baseapp/pages/success-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:baseapp/providers/locale_providers.dart';
import 'package:baseapp/providers/theme_mode_provider.dart';
import 'package:baseapp/utils/user_preferences.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/pages/splash.dart';
import 'package:baseapp/pages/welcome.dart';
import 'package:baseapp/pages/login.dart';
import 'package:baseapp/pages/home.dart';

void main() async {    print('111111');

WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url: 'https://pksazqgsqpaydgxzxjtv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBrc2F6cWdzcXBheWRneHp4anR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDcxNzIwNjQsImV4cCI6MjAyMjc0ODA2NH0.k_XGZ3CA6sYxE-D6f-n93DbUUORrWpdzAnHMGZ554pw', // あなたのanon/public APIキー
  );
  Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
  await UserPreferences.init(deviceLocale);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('222222');

    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider); //
    return MaterialApp(
      routes: {
        '/home': (context) => const HomePage(),
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/splash': (context) => const SplashPage(),
        '/success': (context) => const SuccessPage(),

      },
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          surface: const Color(0xfff5f5f5),
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffF4F3F3), // AppBarの背景色を指定
        ),
      ),
      themeMode: themeMode,

      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ja', ''),
      ],
      home: const SplashPage(), // ここでSplashPageを指定
    );
  }
}
