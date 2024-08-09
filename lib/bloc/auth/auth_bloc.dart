import 'package:apos_app/lib_exp.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial()) {
    on<AuthEventLogin>(_onLogin);
  }

  Future<void> _onLogin(
    AuthEventLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
    Future.delayed(const Duration(seconds: 1));

    emit(AuthStateLoginSuccess());
    return;

    if (event.email.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(
        AuthStateFail(error: ErrorModel(message: "Enter username", code: 1)),
      );
      return;
    }
    if (event.password != "welcome") {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(
        AuthStateFail(error: ErrorModel(message: "Invalid password", code: 2)),
      );
      return;
    }
    if (event.email != "admin") {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(
        AuthStateFail(error: ErrorModel(message: "User not found", code: 1)),
      );
      return;
    }

    if (event.rememberMe) {
      await SpHelper.rememberMe(
        username: event.email,
        password: event.password,
      );
    }

    emit(AuthStateLoginSuccess());
  }
}
