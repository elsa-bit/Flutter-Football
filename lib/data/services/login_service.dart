
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LoginService {
  Future<String> loginAdmin(String email, String password);
  Future<AuthResponse> loginTest(String email, String password);
  Future<String> loginMember(String email, String password);
  Future<String> loginCoach(String email, String password);
}