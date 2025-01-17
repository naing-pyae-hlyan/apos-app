import 'dart:async';
import 'package:apos_app/lib_exp.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial()) {
    on<AuthEventLoading>(_onLoading);
    on<AuthEventLoadingStop>(_onLoadingStop);
    on<AuthEventLogin>(_onLogin);
    on<AuthEventRegisterRequestOTP>(_onRegisterRequestOTP);
    on<AuthEventRegisterActivate>(_onRegisterActivate);
    on<AuthEventForgotPasswordRequestOTP>(_onForgotPasswordRequestOTP);
    on<AuthEventForgotPasswordActivate>(_onForgotPasswordActivate);
    on<AuthEventUpdateCustomerDataRequestOTP>(_onUpdateCustomerDataRequestOTP);
    on<AuthEventUpdateCustomerData>(_onUpdateCustomerData);
    on<AuthEventLogout>(_onLogout);
  }

  Future<void> _onLoading(
    AuthEventLoading event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
  }

  Future<void> _onLoadingStop(
    AuthEventLoadingStop event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoadingStop());
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
            if (event.needToUpdateFavItems) {
              await SpHelper.setFavItems(doc.data().favourites);
            }
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
      emit(_authStateFail(message: "Login: ${error.toString()}", code: 2));
    });
  }

  Future<void> _onRegisterRequestOTP(
    AuthEventRegisterRequestOTP event,
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
          if (event.customer.phone == doc.data().phone) {
            alreadyRegistered = true;
            break;
          }
        }
        if (alreadyRegistered) {
          emit(_authStateFail(
            message: "Your phone is already registered.",
            code: 3,
          ));
          return;
        }
        emit(AuthStateRegisterRequestOTP(event.customer));
      },
    ).catchError((error) {
      emit(_authStateFail(message: error.toString(), code: 5));
    });
  }

  Future<void> _onRegisterActivate(
    AuthEventRegisterActivate event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
    await FFirestoreUtils.customerCollection
        .add(event.customer)
        .then((_) => emit(AuthStateRegisterSuccess()))
        .catchError(
          (error) => emit(
            _authStateFail(message: error.toString(), code: 5),
          ),
        );
  }

  Future<void> _onForgotPasswordRequestOTP(
    AuthEventForgotPasswordRequestOTP event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
    if (event.phone.isEmpty) {
      emit(_authStateFail(message: "Enter Phone", code: 1));
      return;
    }
    if (event.email.isEmpty) {
      emit(_authStateFail(message: "Enter Email", code: 2));
      return;
    }

    await FFirestoreUtils.customerCollection.get().then(
      (QuerySnapshot<CustomerModel> snapshot) async {
        bool accountIsExists = false;
        String? id;
        for (var doc in snapshot.docs) {
          if (event.email == doc.data().email &&
              event.phone == doc.data().phone) {
            id = doc.data().id;
            accountIsExists = true;
            break;
          }
        }
        if (accountIsExists && id != null) {
          emit(AuthStateForgotPasswordRequestOTP(
            id: id,
            phone: event.phone,
            password: event.password,
          ));
        } else {
          emit(_authStateFail(
            message: "Your account does not exist.",
            code: 3,
          ));
        }
      },
    ).catchError((error) {
      emit(_authStateFail(message: error.toString(), code: 3));
    });
  }

  Future<void> _onForgotPasswordActivate(
    AuthEventForgotPasswordActivate event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
    await FFirestoreUtils.customerCollection
        .doc(event.id)
        .update({"password": event.password})
        .then((_) => emit(AuthStateForgotPasswordSuccess()))
        .catchError(
          (error) => emit(_authStateFail(message: error.toString(), code: 3)),
        );
  }

  Future<void> _onUpdateCustomerDataRequestOTP(
    AuthEventUpdateCustomerDataRequestOTP event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
    if (event.newValue.isEmpty) {
      emit(_authStateFail(
        message: "Enter ${event.action.label}",
        code: 1,
      ));
      return;
    }
    if (event.password.isEmpty) {
      emit(_authStateFail(
        message: "Enter password",
        code: 2,
      ));
      return;
    }
    final storedPassword = await SpHelper.password;
    late String hashPassword;
    int code = 2;
    if (event.action == CustomerUpdateAction.password) {
      hashPassword = HashUtils.hashPassword(event.newValue);
      code = 1;
    } else {
      hashPassword = HashUtils.hashPassword(event.password);
    }

    if (storedPassword != hashPassword) {
      emit(_authStateFail(
        message: "Password does not match",
        code: code,
      ));
      return;
    }

    await FFirestoreUtils.customerCollection.get().then(
      (QuerySnapshot<CustomerModel> snapshot) async {
        bool already = false;
        String? message;

        for (var doc in snapshot.docs) {
          String? validator;

          if (event.action == CustomerUpdateAction.emial) {
            validator = doc.data().email;
            message = "email";
          }
          if (event.action == CustomerUpdateAction.phone) {
            validator = doc.data().phone;
            message = "phone";
          }
          if (validator != null && event.newValue == validator) {
            already = true;
            break;
          }
        }
        if (already) {
          emit(_authStateFail(
            message: "Your $message is already registered.",
            code: 1,
          ));
          return;
        }

        emit(AuthStateUpdateCustomerRequestOTP(
          action: event.action,
          newValue: event.newValue,
          password: HashUtils.hashPassword(event.password),
        ));
      },
    ).catchError(
      (error) {
        emit(_authStateFail(message: error.toString(), code: 2));
      },
    );
  }

  Future<void> _onUpdateCustomerData(
    AuthEventUpdateCustomerData event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
    if (event.needToValidate) {
      if (event.newValue.isEmpty) {
        emit(_authStateFail(
          message: "Enter ${event.action.label}",
          code: 1,
        ));
        return;
      }

      final storedPassword = await SpHelper.password;
      if (event.password != storedPassword) {
        emit(_authStateFail(
          message: "Password does not match",
          code: 2,
        ));
        return;
      }
    }

    final Map<String, dynamic> map = {};
    if (event.action == CustomerUpdateAction.password) {
      map[event.action.jsonKey] = event.password;
    } else {
      map[event.action.jsonKey] = event.newValue;
    }

    final String? userId = CacheManager.currentCustomer?.id;
    if (userId == null) {
      emit(AuthStateLoadingStop());
    }
    await FFirestoreUtils.customerCollection
        .doc(userId)
        .update(map)
        .then(
          (_) => emit(AuthStateUpdateCustomerDataSuccess(
            event.action,
            event.newValue,
            event.password,
          )),
        )
        .catchError(
          (error) => emit(_authStateFail(
            message: error.toString(),
            code: 1,
          )),
        );
  }

  Future<void> _onLogout(
    AuthEventLogout event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
    final String? userId = CacheManager.currentCustomer?.id;
    if (userId == null) {
      emit(AuthStateLoadingStop());
    }
    await SpHelper.favItems.then(
      (Map<String, List<String>> favs) async {
        await FFirestoreUtils.customerCollection
            .doc(userId)
            .update({
              "favourites": Map.from(favs).map((k, v) =>
                  MapEntry<String, dynamic>(
                      k, List<dynamic>.from(v.map((x) => x)))),
            })
            .then(
              (_) => emit(AuthStateLogout()),
            )
            .catchError((error) => _authStateFail(
                  message: error.toString(),
                  showErrorDialog: true,
                ));
      },
    );
  }

  AuthStateFail _authStateFail({
    required String message,
    int code = 1,
    bool showErrorDialog = false,
  }) =>
      AuthStateFail(
        error: ErrorModel(message: message, code: code),
        showErrorDialog: showErrorDialog,
      );
}
