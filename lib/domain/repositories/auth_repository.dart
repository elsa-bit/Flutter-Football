import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_football/data/data_sources/auth_data_source.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  User? user = null;
  SharedPreferencesDataSource preferencesDataSource;
  AuthDataSource authDataSource;

  AuthRepository(
      {required this.preferencesDataSource, required this.authDataSource});

  Future<bool> isUserAuthenticated() async {
    final accessToken = preferencesDataSource.getAccessToken();
    if (accessToken == null) return false;

    try {
      final user = await supabase.auth.getUser(accessToken);
      if (user.user == null) return false;
      await saveUser(user.user!);
    } on AuthException catch (e) {
      return await refreshToken();
    } catch (e) {
      rethrow;
    }
    return true;
  }

  Future<bool> refreshToken() async {
    print("Refreshing token...");
    final refreshToken = preferencesDataSource.getRefreshToken();
    if (refreshToken == null) {
      print("No refresh token saved");
      return false;
    }

    final authResponse = await supabase.auth.refreshSession(refreshToken);
    await authenticateUser(authResponse);
    return true;
  }

  Future<void> authenticateUser(AuthResponse auth) async {
    print("Authenticating user...");
    if (auth.user != null) await saveUser(auth.user!);

    final accessToken = auth.session?.accessToken;
    final refreshToken = auth.session?.refreshToken;

    if (accessToken != null) {
      print("Saving access token");
      preferencesDataSource.saveAccessToken(accessToken);
    }

    if (refreshToken != null) {
      print("Saving refresh token");
      preferencesDataSource.saveRefreshToken(refreshToken);
    }
  }

  Future<void> authLogout() async {
    await supabase.auth.signOut();
    user = null;
    await preferencesDataSource.clear();
  }

  Future<void> logout(String mode) async {
    var idUser;
    if (mode == 'player') {
      idUser = preferencesDataSource.getIdPlayer();
    } else if (mode == 'coach') {
      idUser = preferencesDataSource.getIdCoach().toString();
    }

    try {
      await authDataSource.logout(idUser, mode);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> playerHasAccess(String playerId) async {
    try {
      final res = await authDataSource.getPlayerAccess(playerId);
      preferencesDataSource
          .saveTeamsIds(res.map((string) => int.parse(string)).toList());

      return res.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

  // private functions

  Future<void> saveUser(User user) async {
    this.user = user;
    int? idCoach = null;
    String? idPlayer = null;

    if (user.userMetadata?["role"] == "coach") {
      idCoach = user.userMetadata?["idCoach"];
    } else if (user.userMetadata?["role"] == "player") {
      idPlayer = user.userMetadata?["idPlayer"];
    }
    preferencesDataSource.saveIdCoach(idCoach);
    preferencesDataSource.saveIdPlayer(idPlayer);

    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getAPNSToken();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      if (idPlayer != null) {
        await supabase
            .from('player')
            .update({'fcm_token': fcmToken}).eq('id', idPlayer);
      } else if (idCoach != null) {
        await supabase
            .from('coach')
            .update({'fcm_token': fcmToken}).eq('id', idCoach);
      }
    }
  }
}
