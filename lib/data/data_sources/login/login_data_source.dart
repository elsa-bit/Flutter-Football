import 'package:flutter_football/data/services/login_service.dart';
import 'package:flutter_football/main.dart';
import 'package:flutter_football/networking/endpoints.dart';
import 'package:flutter_football/networking/exceptions_factory.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../base_data_source.dart';

class LoginDataSource extends BaseDataSource with LoginService {

  @override
  Future<String> loginAdmin(String email, String password) async {
    final queryParameters = {
      'email': email,
      'password': password,
    };
    final response = await httpPost(Endpoints.loginAdmin, queryParameters);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      final errorMessage = response.body;
      throw ExceptionsFactory().handleStatusCode(response.statusCode, errorMessage: errorMessage);
    }
  }

  @override
  Future<AuthResponse> loginTest(String email, String password) async {
    return supabase.auth.signInWithPassword(password: password, email: email);
  }

  @override
  Future<String> loginCoach(String email, String password) async {
    final queryParameters = {
      'email': email,
      'password': password,
    };
    final response = await httpPost(Endpoints.loginCoach, queryParameters);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw response.body;//ExceptionsFactory().handleStatusCode(response.statusCode);
    }
  }

  @override
  Future<String> loginMember(String email, String password) async {
    final queryParameters = {
      'email': email,
      'password': password,
    };
    final response = await httpPost(Endpoints.loginPlayer, queryParameters);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw response.body;//ExceptionsFactory().handleStatusCode(response.statusCode);
    }
  }

  @override
  Future<AuthResponse> signUpTest(String email, String password, String role) {
    final userData = {
      'firstname': email,
      'lastname': password,
      'avatar': '',
      'tokenPhone': '',
      'role': role,
    };
    return supabase.auth.signUp(password: password, email: email, data: userData);
  }

}