import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart';
import 'package:baseapp/pages/login.dart';
import 'package:baseapp/components/custom_app_bar.dart';

import '../utils/constants.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends ConsumerState<WelcomePage> {
  late final SupabaseService supabaseService;
  @override
  Widget build(BuildContext context) {
    print('99999999');

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('neko'),
                SizedBox(
                    height: 50, child: Image.asset('assets/images/sega2.png')),
                const SizedBox(height: 60),
                SizedBox(
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      S.of(context).loginPageTitle,
                      style: const TextStyle(
                          fontSize: questDescriptionFontSize, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 60.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: const Color(0xffEA5E4C),
                    // ボタンの背景色
                    // foregroundColor: Colors.white,
                    // テキストの色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // ボタンの角の丸み
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    // パディング
                    elevation: 2, // 影の高さ
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // ボタン内のコンテンツサイズに合わせる
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        S.of(context).getStarted,
                        style: const TextStyle(
                          fontSize: 20, // テキストサイズ
                          fontWeight: FontWeight.bold, // フォントの太さ
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0), // アイコンの内側のパディング
                        child: Icon(
                          Icons.arrow_forward, // アイコン
                          // color: Colors.black, // アイコンの色
                          size: 24, // アイコンサイズ
                        ),
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
