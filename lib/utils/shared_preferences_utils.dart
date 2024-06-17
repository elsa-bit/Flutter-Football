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

  static int? getInt(String key) {
    return _prefsInstance.getInt(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return await _prefsInstance.setInt(key, value);
  }

  static List<int>? getIntList(String key) {
    final res = _prefsInstance.getStringList(key);
    return res?.map((e) => int.parse(e)).toList();
  }

  static Future<bool> setIntList(String key, List<int> value) async {
    return await _prefsInstance.setStringList(key, value.map((e) => e.toString()).toList());
  }

  static Future<void> clear() async {
    await _prefsInstance.clear();
  }

  static Future<void> removeKey(String key) async {
    await _prefsInstance.remove(key);
  }
}