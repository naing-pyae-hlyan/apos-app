import 'package:apos_app/lib_exp.dart';

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

class AuthEventRegisterToFirebaseAuth extends AuthEvent {
  final CustomerModel customer;
  AuthEventRegisterToFirebaseAuth({required this.customer});
}

class AuthEventRegisterToFirestore extends AuthEvent {
  CustomerModel customer;
  AuthEventRegisterToFirestore({required this.customer});
}

class AuthEventUpdateCustomer extends AuthEvent {
  CustomerModel customer;
  AuthEventUpdateCustomer({required this.customer});
}
