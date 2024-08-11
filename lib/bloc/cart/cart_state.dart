import 'package:apos_app/lib_exp.dart';

sealed class CartState {}

class CartStateInitial extends CartState {}

class CartStateLoading extends CartState {}

class CartStateFail extends CartState {
  final ErrorModel error;
  CartStateFail({required this.error});
}

class CartStateAddItemSuccess extends CartState {}

class CartStateUpdateItemSuccess extends CartState {}

class CartStateRemoveItemSuccess extends CartState {}

class CartStateEditChangeItemQtySuccess extends CartState {}

class CartStateItemsClearSuccess extends CartState {}
