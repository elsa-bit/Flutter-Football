
abstract class AuthEvent {}

class IsUserAuthenticated extends AuthEvent {
  IsUserAuthenticated();
}

class AuthenticateUser extends AuthEvent {
  final String token;

  AuthenticateUser({
    required this.token
  });
}