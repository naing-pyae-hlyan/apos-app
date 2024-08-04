import 'package:apos_app/lib_exp.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersStateInitial()) {
    on<OrdersEventAddItem>(_onItemAdd);
  }
  final List<Item> _items = [];
  List<Item> get items => _items;

  int get itemsQty {
    int qty = 0;
    for (Item item in _items) {
      qty += item.qty;
    }
    return qty;
  }

  int get itemsTotalPrice {
    int total = 0;
    for (Item item in _items) {
      total += item.totalPrice.round();
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
