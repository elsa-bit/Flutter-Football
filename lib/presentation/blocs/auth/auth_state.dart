
enum AuthStatus {
  unknown,
  loading,
  authenticated,
  unauthenticated,
  error
}

class AuthState {
  final AuthStatus status;
  final String? error;

  AuthState({
    this.status = AuthStatus.unknown,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? error,
  }) {
    return AuthState(
        status: status ?? this.status,
        error: error ?? this.error,
    );
  }
}