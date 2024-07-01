import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

enum AuthStatus {
  unknown,
  loading,
  authenticatedAsCoach,
  authenticatedAsPlayer,
  playerAccessForbidden,
  unauthenticated,
  error
}

class AuthState {
  final AuthStatus status;
  final String? error;
  final User? user;

  AuthState({this.status = AuthStatus.unknown, this.error, this.user});

  AuthState copyWith({
    AuthStatus? status,
    String? error,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}
