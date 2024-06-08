import 'package:flutter_football/utils/shared_preferences_utils.dart';

class SharedPreferencesDataSource {

  Future<bool> saveAccessToken(String token) async {
    return await SharedPreferencesUtils.setString(SharedPreferencesKeys.accessToken.name, token);
  }

  String? getAccessToken() {
    return SharedPreferencesUtils.getString(SharedPreferencesKeys.accessToken.name);
  }

  Future<bool> saveRefreshToken(String token) async {
    return await SharedPreferencesUtils.setString(SharedPreferencesKeys.refreshToken.name, token);
  }

  String? getRefreshToken() {
    return SharedPreferencesUtils.getString(SharedPreferencesKeys.refreshToken.name);
  }

  Future<void> clear() async {
    await SharedPreferencesUtils.clear();
  }

}

enum SharedPreferencesKeys {
  accessToken,
  refreshToken,
}