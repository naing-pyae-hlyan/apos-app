import 'package:apos_app/lib_exp.dart';

sealed class AuthState {}

class AuthStateInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateLoadingStop extends AuthState {}

class AuthStateFail extends AuthState {
  final ErrorModel error;
  AuthStateFail({required this.error});
}

class AuthStateLoginSuccess extends AuthState {}

class AuthStateRegisterRequestOTP extends AuthState {
  final CustomerModel customer;
  AuthStateRegisterRequestOTP(this.customer);
}

class AuthStateRegisterSuccess extends AuthState {}

class AuthStateForgotPasswordRequestOTP extends AuthState {
  final String id;
  final String phone;
  final String password;
  AuthStateForgotPasswordRequestOTP({
    required this.id,
    required this.phone,
    required this.password,
  });
}

class AuthStateForgotPasswordSuccess extends AuthState {}

class AuthStateUpdateCustomerSuccess extends AuthState {
  final CustomerModel customer;
  AuthStateUpdateCustomerSuccess(this.customer);
}
