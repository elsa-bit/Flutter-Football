import 'dart:convert';

import 'package:flutter_football/data/data_sources/login/login_data_source.dart';
import 'package:flutter_football/domain/models/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;


class LoginRepository {
  final LoginDataSource loginDataSource;

  LoginRepository({
    required this.loginDataSource,
  });


  Future<AuthResponse> login(String email, String password) async {
    try {
      return loginDataSource.login(email, password);
    } catch(error) {
      print(error);
      rethrow;
    }
  }


}