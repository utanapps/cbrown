import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/generated/l10n.dart';
import 'package:baseapp/providers/locale_providers.dart';
import 'package:baseapp/utils/user_preferences.dart';

void showLanguageSelectionDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).selectLanguage),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Locale>[
              const Locale('en', ''),
              const Locale('ja', ''),
            ]
                .map((Locale locale) => RadioListTile<Locale>(
                      title:
                          Text(locale.languageCode == 'en' ? 'English' : '日本語'),
                      value: locale,
                      groupValue: ref.read(localeProvider),
                      onChanged: (Locale? newValue) {
                        ref.read(localeProvider.notifier).state = newValue!;
                        Navigator.of(context).pop();
                        UserPreferences.setLocale(newValue.languageCode);
                      },
                    ))
                .toList(),
          ),
        ),
      );
    },
  );
}
