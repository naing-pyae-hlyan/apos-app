import 'package:apos_app/lib_exp.dart';

sealed class ErrorEvent {}

class ErrorEventSetError extends ErrorEvent {
  final String? errorKey;
  final ErrorModel? error;
  ErrorEventSetError({
    required this.errorKey,
    required this.error,
  });
}

class ErrorEventResert extends ErrorEvent {}
