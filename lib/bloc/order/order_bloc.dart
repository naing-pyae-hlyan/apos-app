import 'package:apos_app/lib_exp.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderStateInitial()) {
    on<OrderEventSubmitOrder>(_onSubmit);
  }

  Future<void> _onSubmit(
    OrderEventSubmitOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderStateLoading());
    await FFirestoreUtils.orderCollection
        .add(event.order)
        .then(
          (_) => emit(OrderStateSubmitSuccess()),
        )
        .catchError(
      (error) {
        emit(OrderStateFail(error: ErrorModel(message: error.toString())));
      },
    );
  }
}
