import 'package:apos_app/lib_exp.dart';

sealed class OrdersEvent {}

class OrdersEventAddItem extends OrdersEvent {
  final Item item;
  OrdersEventAddItem({required this.item});
}
