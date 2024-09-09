import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/supabase_service.dart'; // 必要に応じて修正してください
import 'package:baseapp/providers/theme_mode_provider.dart';
import 'package:baseapp/components/language_selection_dialog.dart';
import 'package:baseapp/pages/edit_profile.dart';
import 'package:baseapp/pages/edit_bank_info.dart';
import 'package:baseapp/pages/password_reset_page.dart';
import 'package:baseapp/pages/change_email_page.dart';
import 'package:baseapp/pages/delete_user.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage> {
  late final SupabaseService supabaseService; // SupabaseServiceのインスタンスを保持する変数

  @override
  void initState() {
    super.initState();
    supabaseService =
        ref.read(supabaseServiceProvider); // SupabaseServiceを一度だけ取得
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: ListView(
        children: [
          // ダークモードのスイッチ
          SwitchListTile(
            title: Text(S.of(context).darkMode),
            value: themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              ref
                  .read(themeModeProvider.notifier)
                  .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
            subtitle: Text(S.of(context).darkModeDescription),
            secondary: Icon(themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode),
          ),
          // 言語設定
          ListTile(
            title: Text(S.of(context).languageMode),
            subtitle: Text(S.of(context).languageDescription),
            leading: const Icon(Icons.language),
            onTap: () => showLanguageSelectionDialog(context, ref),
          ),
          ListTile(
            title: Text(S.of(context).profile),
            subtitle: Text(S.of(context).profileDescription),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const EditProfile(), // ChatPageはチャット画面のクラス
                ),
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).bankDetail),
            subtitle: Text(S.of(context).paymentDescription),
            leading: const Icon(Icons.account_balance),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const EditBankInfo(), // ChatPageはチャット画面のクラス
                ),
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).email),
            subtitle: Text(S.of(context).emailChange),
            leading: const Icon(Icons.email),
            onTap: () {
              // Navigator.of(context).pop(); // ドロワーを閉じる
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const ChangeEmailPage()),
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).password),
            subtitle: Text(S.of(context).passwordChange),
            leading: const Icon(Icons.security),
            onTap: () {
              // Navigator.of(context).pop(); // ドロワーを閉じる
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const PasswordResetPage()),
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).delete),
            subtitle: Text(S.of(context).passwordChange),
            leading: const Icon(Icons.security),
            onTap: () {
              // Navigator.of(context).pop(); // ドロワーを閉じる
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DeleteUser()),
              );
            },
          ),
          ListTile(
            title: Text(S.of(context).logout),
            subtitle: Text(S.of(context).logoutDescription),
            leading: const Icon(Icons.logout),
            onTap: () async {
              // Navigatorを使用する前にcontextからNavigatorを取得
              var navigator = Navigator.of(context);

              // 非同期処理を実行
              await supabaseService.logout();

              // ここでmountedをチェックすることもできますが、ConsumerWidgetでは直接使用できないため、
              // 取得したnavigatorを使って画面遷移を行います。
              if (navigator.canPop()) {
                // 画面遷移が可能かどうかを確認
                navigator.pop(); // ドロワーを閉じる
              }
            },
          ),
        ],
      ),
    );
  }
}
