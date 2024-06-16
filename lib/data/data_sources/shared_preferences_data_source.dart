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

  Future<bool> saveIdCoach(int id) async {
    return await SharedPreferencesUtils.setInt(SharedPreferencesKeys.idCoach.name, id);
  }

  int? getIdCoach() {
    return SharedPreferencesUtils.getInt(SharedPreferencesKeys.idCoach.name);
  }

  Future<bool> saveTeamsIds(List<int> teamsId) async {
    return await SharedPreferencesUtils.setIntList(SharedPreferencesKeys.teamsId.name, teamsId);
  }

  List<int>? getTeamsIds() {
    return SharedPreferencesUtils.getIntList(SharedPreferencesKeys.teamsId.name);
  }

  Future<bool> saveIdPlayer(int id) async {
    return await SharedPreferencesUtils.setInt(SharedPreferencesKeys.idPlayer.name, id);
  }

  int? getIdPlayer() {
    return SharedPreferencesUtils.getInt(SharedPreferencesKeys.idPlayer.name);
  }

  Future<void> clear() async {
    await SharedPreferencesUtils.clear();
  }

}

enum SharedPreferencesKeys {
  accessToken,
  refreshToken,
  idCoach,
  idPlayer,
  teamsId,
}