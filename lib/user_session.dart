import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static SharedPreferences? _preferences;
  static const _keySession = 'userSession';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setSession(String session) async =>
      await _preferences?.setString(_keySession, session);

  static String? getSession() => _preferences?.getString(_keySession);
}
