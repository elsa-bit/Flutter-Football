
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

class LoginTest extends LoginEvent {
  final String email;
  final String password;

  LoginTest({
    required this.email,
    required this.password,
  });
}