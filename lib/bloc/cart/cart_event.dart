import 'package:apos_app/lib_exp.dart';

sealed class CartEvent {}

class CartEventAddItem extends CartEvent {
  final ItemModel item;
  CartEventAddItem({required this.item});
}

class CartEventUpdateItem extends CartEvent {
  final ItemModel item;
  CartEventUpdateItem({required this.item});
}

class CartEventRemoveItem extends CartEvent {
  final String itemId;
  CartEventRemoveItem({required this.itemId});
}

class CartEventChangeItemQty extends CartEvent {
  final String itemId;
  final int newQty;
  CartEventChangeItemQty({required this.itemId, required this.newQty});
}


class CartEventResetItems extends CartEvent{}