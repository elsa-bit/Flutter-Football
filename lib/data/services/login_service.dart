
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LoginService {
  Future<AuthResponse> login(String email, String password);
}