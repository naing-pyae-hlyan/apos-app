import 'package:apos_app/lib_exp.dart';

sealed class AuthEvent {}

class AuthEventLogin extends AuthEvent {
  String email;
  String password;
  bool rememberMe;
  bool needToUpdateFavItems;
  AuthEventLogin({
    required this.email,
    required this.password,
    required this.rememberMe,
    required this.needToUpdateFavItems,
  });
}

class AuthEventLoading extends AuthEvent {}

class AuthEventLoadingStop extends AuthEvent {}

class AuthEventRegisterRequestOTP extends AuthEvent {
  CustomerModel customer;
  AuthEventRegisterRequestOTP({required this.customer});
}

class AuthEventRegisterActivate extends AuthEvent {
  CustomerModel customer;
  AuthEventRegisterActivate(this.customer);
}

class AuthEventForgotPasswordRequestOTP extends AuthEvent {
  final String password;
  final String phone;
  final String email;
  AuthEventForgotPasswordRequestOTP({
    required this.password,
    required this.phone,
    required this.email,
  });
}

class AuthEventForgotPasswordActivate extends AuthEvent {
  final String id;
  final String password;
  final String phone;
  AuthEventForgotPasswordActivate({
    required this.id,
    required this.password,
    required this.phone,
  });
}

class AuthEventUpdateCustomerDataRequestOTP extends AuthEvent {
  final CustomerUpdateAction action;
  final String newValue;
  final String password;

  AuthEventUpdateCustomerDataRequestOTP({
    required this.action,
    required this.newValue,
    required this.password,
  });
}

class AuthEventUpdateCustomerData extends AuthEvent {
  final bool needToValidate;
  final CustomerUpdateAction action;
  final String newValue;
  final String password;

  AuthEventUpdateCustomerData({
    required this.needToValidate,
    required this.action,
    required this.newValue,
    required this.password,
  });
}

class AuthEventLogout extends AuthEvent {}
