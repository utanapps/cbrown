import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baseapp/utils/user_preferences.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    // 初期値はシステムのテーマに依存
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final themeModeStr = UserPreferences.getThemeMode();
    state = ThemeMode.values.firstWhere((e) => e.toString() == themeModeStr,
        orElse: () => ThemeMode.system);
  }

  void setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await UserPreferences.setThemeMode(themeMode.toString());
  }
}
