import 'package:apos_app/lib_exp.dart';

sealed class ErrorState {}

class ErrorStateInitial extends ErrorState {}

class ErrorStateHasError extends ErrorState {
  final String errorKey;
  final ErrorModel error;
  ErrorStateHasError({
    required this.errorKey,
    required this.error,
  });
}

class ErrorStateNoError extends ErrorState {}
