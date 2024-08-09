import 'package:apos_app/lib_exp.dart';

class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  ErrorBloc() : super(ErrorStateInitial()) {
    on<ErrorEventSetError>(_onErrorSet);
    on<ErrorEventResert>(_onErrorReset);
  }

  Future<void> _onErrorSet(
    ErrorEventSetError event,
    Emitter<ErrorState> emit,
  ) async {
    if (event.errorKey == null || event.error == null) {
      emit(ErrorStateNoError());
      return;
    }
    emit(ErrorStateHasError(
      errorKey: event.errorKey!,
      error: event.error!,
    ));
  }

  Future<void> _onErrorReset(
    ErrorEventResert event,
    Emitter<ErrorState> emit,
  ) async {
    emit(ErrorStateNoError());
  }
}
