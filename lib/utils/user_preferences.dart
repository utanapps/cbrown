import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;
  static const _keyLocale = 'locale';
  static const _keyThemeMode = 'themeMode';

  // SharedPreferencesの初期化
  static Future<void> init(Locale deviceLocale) async {
    _preferences = await SharedPreferences.getInstance();
    String initialLocale = getLocale();
    if (initialLocale.isEmpty) {
      await setLocale(deviceLocale.languageCode);
    }
  }

  static Future<void> setLocale(String locale) async {
    await _preferences?.setString(_keyLocale, locale);
  }

  static String getLocale() {
    return _preferences?.getString(_keyLocale) ?? '';
  }

  static Future<void> setThemeMode(String themeMode) async {
    await _preferences?.setString(_keyThemeMode, themeMode);
  }

  static String getThemeMode() {
    return _preferences?.getString(_keyThemeMode) ?? 'System';
  }
}
