
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthEvent {}

class IsUserAuthenticated extends AuthEvent {
  IsUserAuthenticated();
}

class AuthenticateUser extends AuthEvent {
  final AuthResponse auth;

  AuthenticateUser({
    required this.auth
  });
}

class AuthenticateUserWithToken extends AuthEvent {
  final String token;

  AuthenticateUserWithToken({
    required this.token
  });
}

class Logout extends AuthEvent {
  Logout();
}