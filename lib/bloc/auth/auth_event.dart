sealed class AuthEvent {}

class AuthEventLogin extends AuthEvent {
  String username;
  String password;
  bool rememberMe;
  AuthEventLogin({
    required this.username,
    required this.password,
    required this.rememberMe,
  });
}
