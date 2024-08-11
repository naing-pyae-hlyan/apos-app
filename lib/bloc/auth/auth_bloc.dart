import 'package:apos_app/lib_exp.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial()) {
    on<AuthEventLogin>(_onLogin);
    on<AuthEventRegister>(_onRegister);
  }

  Future<void> _onLogin(
    AuthEventLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
    if (event.email.isEmpty) {
      emit(_authStateFail(message: "Enter Email", code: 1));
      return;
    }
    if (event.password.isEmpty) {
      emit(_authStateFail(message: "Enter Password", code: 2));
      return;
    }

    final hashPassword = HashUtils.hashPassword(event.password);

    await FFirestoreUtils.customerCollection.get().then(
      (QuerySnapshot<CustomerModel> snapshot) async {
        bool authorize = false;
        for (var doc in snapshot.docs) {
          if (event.email == doc.data().email &&
              hashPassword == doc.data().password) {
            authorize = true;
            CacheManager.currentCustomer = doc.data();
            break;
          }
        }

        if (authorize) {
          await SpHelper.rememberMe(
            email: event.email,
            password: event.password,
          );
          emit(AuthStateLoginSuccess());
        } else {
          emit(_authStateFail(message: "Invalid Email or Password", code: 2));
        }
      },
    ).catchError((error) {
      emit(_authStateFail(message: error.toString(), code: 2));
    });
  }

  Future<void> _onRegister(
    AuthEventRegister event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());

    if (event.customer.name.isEmpty) {
      emit(_authStateFail(message: "Enter Name", code: 1));
      return;
    }

    if (event.customer.email.isEmpty) {
      emit(_authStateFail(message: "Enter Email", code: 2));
      return;
    }

    if (event.customer.phone.isEmpty) {
      emit(_authStateFail(message: "Enter Phone", code: 3));
      return;
    }

    if (event.customer.address.isEmpty) {
      emit(_authStateFail(message: "Enter Address", code: 4));
      return;
    }

    if (event.customer.password?.isEmpty == true) {
      emit(_authStateFail(message: "Enter Password", code: 5));
      return;
    }

    await FFirestoreUtils.customerCollection.get().then(
      (QuerySnapshot<CustomerModel> snapshot) async {
        bool alreadyRegistered = false;
        for (var doc in snapshot.docs) {
          if (event.customer.email == doc.data().email) {
            alreadyRegistered = true;
            break;
          }
        }
        if (alreadyRegistered) {
          emit(_authStateFail(
            message: "Your email is already registered.",
            code: 2,
          ));
          return;
        }

        await FFirestoreUtils.customerCollection
            .add(event.customer)
            .then((_) => emit(AuthStateRegisterSuccess()))
            .catchError(
              (error) => emit(
                _authStateFail(message: error.toString(), code: 5),
              ),
            );
      },
    ).catchError((error) {
      emit(_authStateFail(message: error.toString(), code: 5));
    });
  }

  AuthStateFail _authStateFail({
    required String message,
    int code = 1,
  }) =>
      AuthStateFail(error: ErrorModel(message: message, code: code));
}
