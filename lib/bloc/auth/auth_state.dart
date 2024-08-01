import 'package:apos_app/models/error_model.dart';

sealed class AuthState {}

class AuthStateInitial extends AuthState {}

class AuthStateLoading extends AuthState {}

class AuthStateFail extends AuthState {
  final ErrorModel error;
  AuthStateFail({required this.error});
}

class AuthStateSuccess extends AuthState {}
