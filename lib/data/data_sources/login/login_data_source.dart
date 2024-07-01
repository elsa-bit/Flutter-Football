import 'package:flutter_football/data/services/login_service.dart';
import 'package:flutter_football/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../base_data_source.dart';

class LoginDataSource extends BaseDataSource with LoginService {
  @override
  Future<AuthResponse> login(String email, String password) async {
    return supabase.auth.signInWithPassword(password: password, email: email);
  }
}