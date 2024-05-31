
enum LoginStatus {
  initial,
  loading,
  success,
  error
}

class LoginState {
  final LoginStatus status;
  final String? error;
  final String? token;

  LoginState({
    this.status = LoginStatus.initial,
    this.error,
    this.token,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? error,
    String? token,
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error ?? this.error,
      token: token ?? this.token,
    );
  }
}