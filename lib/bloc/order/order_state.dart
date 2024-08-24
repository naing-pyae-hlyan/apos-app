import 'package:apos_app/lib_exp.dart';

sealed class OrderState {}

class OrderStateInitial extends OrderState {}

class OrderStateLoading extends OrderState {}

class OrderStateStopLoading extends OrderState {}

class OrderStateFail extends OrderState {
  final ErrorModel error;
  OrderStateFail({required this.error});
}

class OrderStateSubmitSuccess extends OrderState {}
