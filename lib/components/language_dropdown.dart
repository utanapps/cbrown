import 'package:baseapp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/providers/locale_providers.dart'; // 正しいパスに修正してください
import 'package:baseapp/utils/user_preferences.dart'; // 正しいパスに修正してください

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final locale = ref.watch(localeProvider);

    return PopupMenuButton<Locale>(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Rowのサイズを子ウィジェットに合わせる
          children: <Widget>[
            const Icon(Icons.language), // 言語アイコン
            Text(
              S.of(context).language,
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
      onSelected: (Locale newLocale) async {
        await UserPreferences.setLocale(newLocale.languageCode);
        ref.read(localeProvider.notifier).state = newLocale;
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        const PopupMenuItem<Locale>(
          value: Locale('en', ''),
          child: Text('English'),
          // child: Text('English', style: TextStyle(fontSize: baseFontSize)),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('ja', ''),
          child: Text('日本語'),
          // child: Text('日本語', style: TextStyle(fontSize: baseFontSize)),
        ),
      ],
    );
  }
}
