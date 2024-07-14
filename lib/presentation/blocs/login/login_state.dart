
import 'package:supabase_flutter/supabase_flutter.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  signUpSuccess,
  error
}

class LoginState {
  final LoginStatus status;
  final Exception? error;
  final String? token;
  final AuthResponse? authResponse;

  LoginState({
    this.status = LoginStatus.initial,
    this.error,
    this.token,
    this.authResponse,
  });

  LoginState copyWith({
    LoginStatus? status,
    Exception? error,
    String? token,
    AuthResponse? authResponse,
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error ?? this.error,
      token: token ?? this.token,
      authResponse: authResponse ?? this.authResponse,
    );
  }
}