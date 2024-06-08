import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' show Future;

class SharedPreferencesUtils {
  static late SharedPreferences _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  static String? getString(String key) {
    return _prefsInstance.getString(key);
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefsInstance.setString(key, value);
  }

  static Future<void> clear() async {
    await _prefsInstance.clear();
  }
}