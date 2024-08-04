import 'package:apos_app/lib_exp.dart';

sealed class DbState {}

class DbStateInitial extends DbState {}

class DbStateLoading extends DbState {}

class DbStateFail extends DbState {
  final ErrorModel error;
  DbStateFail({required this.error});
}

class DbStateGetProductsWithCategoryFromServerSuccess extends DbState {}
