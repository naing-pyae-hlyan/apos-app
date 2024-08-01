import 'package:apos_app/lib_exp.dart';

sealed class ItemState {}

class ItemStateInitial extends ItemState {}

class ItemStateLoading extends ItemState {}

class ItemStateFail extends ItemState {
  final ErrorModel error;
  ItemStateFail({required this.error});
}

class ItemStateSuccess extends ItemState {}
