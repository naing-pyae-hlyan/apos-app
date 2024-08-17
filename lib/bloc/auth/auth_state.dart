import 'package:apos_app/lib_exp.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthState {}

class AuthStateInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateFail extends AuthState {
  final ErrorModel error;
  AuthStateFail({required this.error});
}

class AuthStateLoginSuccess extends AuthState {}

class AuthStateRegisterSendVerification extends AuthState {
  final User? user;
  final CustomerModel customer;
  AuthStateRegisterSendVerification({
    required this.user,
    required this.customer,
  });
}

class AuthStateRegisterToFirestoreSuccess extends AuthState {}

class AuthStateUpdateCustomerSuccess extends AuthState {
  final CustomerModel customer;
  AuthStateUpdateCustomerSuccess(this.customer);
}
