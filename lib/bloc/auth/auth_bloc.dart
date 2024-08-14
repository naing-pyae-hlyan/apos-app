import 'dart:async';

import 'package:apos_app/lib_exp.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial()) {
    on<AuthEventLogin>(_onLogin);
    on<AuthEventRegister>(_onRegister);
    on<AuthEventUpdateCustomer>(_onUpdateCustomer);
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

    await FFirestoreUtils.customerCollection.get().then(
      (QuerySnapshot<CustomerModel> snapshot) async {
        bool authorize = false;
        bool accountIsActive = true;
        for (var doc in snapshot.docs) {
          if (event.email == doc.data().email &&
              event.password == doc.data().password) {
            authorize = true;
            accountIsActive = doc.data().status == 1;
            CacheManager.currentCustomer = doc.data();
            break;
          }
        }

        if (authorize && accountIsActive) {
          await SpHelper.rememberMe(
            email: event.email,
            password: event.password,
          );
          emit(AuthStateLoginSuccess());
        } else if (!accountIsActive) {
          emit(_authStateFail(message: "Your account is disabled.", code: 2));
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

  Future<void> _onUpdateCustomer(
    AuthEventUpdateCustomer event,
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

    final hashPassword = HashUtils.hashPassword(event.customer.password ?? "");
    final storedPassword = await SpHelper.password;
    if (hashPassword != storedPassword) {
      emit(_authStateFail(message: "Password does not match", code: 5));
      return;
    }

    await FFirestoreUtils.customerCollection
        .doc(event.customer.id)
        .update(event.customer.toJson())
        .then((_) => emit(AuthStateUpdateCustomerSuccess(event.customer)))
        .catchError(
          (error) => emit(_authStateFail(message: error.toString(), code: 5)),
        );
  }

  AuthStateFail _authStateFail({
    required String message,
    int code = 1,
  }) =>
      AuthStateFail(error: ErrorModel(message: message, code: code));
}
