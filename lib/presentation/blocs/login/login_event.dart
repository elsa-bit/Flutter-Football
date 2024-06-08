
abstract class LoginEvent {}

class LoginCoach extends LoginEvent {
  final String email;
  final String password;

  LoginCoach({
    required this.email,
    required this.password,
  });
}

class LoginMember extends LoginEvent {
  final String email;
  final String password;

  LoginMember({
    required this.email,
    required this.password,
  });
}

class Login extends LoginEvent {
  final String email;
  final String password;

  Login({
    required this.email,
    required this.password,
  });
}

class SignUpTest extends LoginEvent {
  final String email;
  final String password;
  final String role;

  SignUpTest({
    required this.email,
    required this.password,
    required this.role,
  });
}