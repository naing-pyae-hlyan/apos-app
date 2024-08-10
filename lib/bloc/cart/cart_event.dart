import 'package:apos_app/lib_exp.dart';

sealed class CartEvent {}

class CartEventAddItem extends CartEvent {
  final ItemModel item;
  CartEventAddItem({required this.item});
}
