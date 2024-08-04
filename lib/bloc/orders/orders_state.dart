import 'package:apos_app/lib_exp.dart';

sealed class OrdersState {}

class OrdersStateInitial extends OrdersState {}

class OrdersStateLoading extends OrdersState {}

class ItemStateFail extends OrdersState {
  final ErrorModel error;
  ItemStateFail({required this.error});
}

class ItemStateAddItemSuccess extends OrdersState {}
