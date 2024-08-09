sealed class AuthEvent {}

class AuthEventLogin extends AuthEvent {
  String email;
  String password;
  bool rememberMe;
  AuthEventLogin({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}
