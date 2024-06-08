import 'dart:convert';

import 'package:flutter_football/data/data_sources/login/login_data_source.dart';
import 'package:flutter_football/domain/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;


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

  Future<AuthResponse> signUpTest(String email, String password, String role) async {
    try {
      return loginDataSource.signUpTest(email, password, role);
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<User> loginCoach(String email, String password) async {
    try {
      final response = await loginDataSource.loginCoach(email, password);
      final data = jsonDecode(response)["coachInformation"] as dynamic;
      return Coach.fromJson(data);
    } catch(error) {
      print(error);
      rethrow;
    }
  }

  Future<User> loginMember(String email, String password) async {
    try {
      final response = await loginDataSource.loginMember(email, password);
      final data = jsonDecode(response)["playerInformation"] as dynamic;
      return Member.fromJson(data);
    } catch(error) {
      print(error);
      rethrow;
    }
  }


}