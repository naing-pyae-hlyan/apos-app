import 'package:apos_app/lib_exp.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderStateInitial()) {
    on<OrderEventSubmitOrder>(_onSubmit);
    on<OrderEventStopLoading>(_stopLoading);
  }

  Future<void> _stopLoading(
    OrderEventStopLoading event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderStateStopLoading());
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
