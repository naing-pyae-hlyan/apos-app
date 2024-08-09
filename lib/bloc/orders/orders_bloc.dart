import 'package:apos_app/lib_exp.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersStateInitial()) {
    on<OrdersEventAddItem>(_onItemAdd);
  }
  final List<ItemModel> _items = [];
  List<ItemModel> get items => _items;

  int get itemsQty {
    int qty = 0;
    for (ItemModel item in _items) {
      qty += item.quantity;
    }
    return qty;
  }

  int get itemsTotalPrice {
    int total = 0;
    for (ItemModel item in _items) {
      total += item.amount.round();
    }
    return total;
  }

  Future<void> _onItemAdd(
    OrdersEventAddItem event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersStateLoading());
    _items.add(event.item);
    emit(ItemStateAddItemSuccess());
  }
}
