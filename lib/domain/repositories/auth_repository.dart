import 'package:flutter/cupertino.dart';
import 'package:flutter_football/data/data_sources/shared_preferences_data_source.dart';
import 'package:flutter_football/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  User? user;
  SharedPreferencesDataSource preferencesDataSource;

  AuthRepository({required this.preferencesDataSource});

  Future<bool> isUserAuthenticated() async {
    final accessToken = preferencesDataSource.getAccessToken();
    if (accessToken == null) return false;

    try {
      final user = await supabase.auth.getUser(accessToken);
      if (user.user == null) return false;
      saveUser(user.user!);
    } on AuthException catch (e) {
      return refreshToken();
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
    authenticateUser(authResponse);
    return true;
  }

  Future<void> authenticateUser(AuthResponse auth) async {
    print("Authenticating user...");
    if (auth.user != null) saveUser(auth.user!);

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

  Future<void> logout() async {
    supabase.auth.signOut();
    user = null;
    await preferencesDataSource.clear();
  }

  // private functions

  void saveUser(User user) {
    this.user = user;
    int? idCoach = null;
    int? idPlayer = null;

    if (user.userMetadata?["role"] == "coach") {
      idCoach = user.userMetadata?["idCoach"];
    } else if (user.userMetadata?["role"] == "player") {
      idPlayer = user.userMetadata?["idPlayer"];
    }
    preferencesDataSource.saveIdCoach(idCoach);
    preferencesDataSource.saveIdPlayer(idPlayer);
  }
}
