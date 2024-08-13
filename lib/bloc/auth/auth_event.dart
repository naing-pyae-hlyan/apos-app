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

class AuthEventRegister extends AuthEvent {
  CustomerModel customer;
  AuthEventRegister({required this.customer});
}

class AuthEventUpdateFcm extends AuthEvent {
  final String? customerId;
  final String? fcmToken;
  AuthEventUpdateFcm({
    required this.customerId,
    required this.fcmToken,
  });
}

class AuthEventUpdateCustomer extends AuthEvent {
  CustomerModel customer;
  AuthEventUpdateCustomer({required this.customer});
}
