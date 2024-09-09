import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/components/language_dropdown.dart';
import 'package:baseapp/components/rounded_close_button.dart'; // RoundedCloseButtonのインポート
import 'package:baseapp/providers/theme_mode_provider.dart';
import 'package:baseapp/utils/user_preferences.dart';

import 'language_selection_dialog.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showCloseButton; // 引数で閉じるボタンの表示を制御

  const CustomAppBar({
    super.key,
    this.showCloseButton = false, // デフォルトは閉じるボタンを表示しない
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    IconData themeIcon =
        themeMode == ThemeMode.dark ? Icons.wb_sunny : Icons.nightlight_round;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: showCloseButton ? const RoundedCloseButton() : null,
      // showCloseButtonがtrueの場合にRoundedCloseButtonを表示
      actions: [
        IconButton(
          icon: Icon(themeIcon),
          onPressed: () async {
            final newThemeMode =
                themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            await UserPreferences.setThemeMode(
                newThemeMode == ThemeMode.dark ? 'Dark' : 'Light');
            ref.read(themeModeProvider.notifier).setThemeMode(newThemeMode);
          },
        ),
        // const LanguageDropdown(),
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: () {
            showLanguageSelectionDialog(context, ref);
          },
          tooltip: 'language',
          highlightColor: Colors.blue[200],
          splashColor: Colors.blue[300],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
