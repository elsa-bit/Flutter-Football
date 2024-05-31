import 'package:flutter_football/data/data_sources/login/login_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class LoginRepository {
  final LoginDataSource loginDataSource;

  LoginRepository({
    required this.loginDataSource,
  });

  Future<String> loginAdmin(String email, String password) async {
    try {
      return loginDataSource.loginAdmin(email, password);
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<AuthResponse> loginTest(String email, String password) async {
    try {
      return loginDataSource.loginTest(email, password);
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<String> loginCoach(String email, String password) async {
    try {
      return loginDataSource.loginCoach(email, password);
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<String> loginMember(String email, String password) async {
    try {
      return loginDataSource.loginMember(email, password);
    } catch(error) {
      print(error);
      rethrow;
    }
  }


}