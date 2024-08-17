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

class AuthEventLoading extends AuthEvent {}

class AuthEventRegisterRequestOTP extends AuthEvent {
  CustomerModel customer;
  AuthEventRegisterRequestOTP({required this.customer});
}

class AuthEventRegisterActivate extends AuthEvent {
  CustomerModel customer;
  AuthEventRegisterActivate(this.customer);
}

class AuthEventUpdateCustomer extends AuthEvent {
  CustomerModel customer;
  AuthEventUpdateCustomer({required this.customer});
}
