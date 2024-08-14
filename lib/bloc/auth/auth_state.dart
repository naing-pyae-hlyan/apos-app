import 'package:apos_app/lib_exp.dart';

sealed class AuthState {}

class AuthStateInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateFail extends AuthState {
  final ErrorModel error;
  AuthStateFail({required this.error});
}

class AuthStateLoginSuccess extends AuthState {}

class AuthStateRegisterSuccess extends AuthState {}

class AuthStateUpdateCustomerSuccess extends AuthState {
  final CustomerModel customer;
  AuthStateUpdateCustomerSuccess(this.customer);
}
