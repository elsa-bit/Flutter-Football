import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthEvent {}

class IsUserAuthenticated extends AuthEvent {
  IsUserAuthenticated();
}

class AuthenticateUser extends AuthEvent {
  final AuthResponse auth;

  AuthenticateUser({required this.auth});
}

class AuthLogout extends AuthEvent {
  AuthLogout();
}

class Logout extends AuthEvent {
  final String mode;

  Logout({required this.mode});
}

class ClearAuthStates extends AuthEvent {
  ClearAuthStates();
}
