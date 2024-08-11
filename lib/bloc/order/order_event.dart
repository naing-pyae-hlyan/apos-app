import 'package:apos_app/lib_exp.dart';

sealed class OrderEvent {}

class OrderEventSubmitOrder extends OrderEvent {
  final OrderModel order;
  OrderEventSubmitOrder({required this.order});
}
