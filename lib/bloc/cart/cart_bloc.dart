import 'package:apos_app/lib_exp.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartStateInitial()) {
    on<CartEventAddItem>(_onItemAdd);
  }

  final List<ItemModel> _items = [];
  List<ItemModel> get items => _items;

  int get totalItemsQty {
    int qty = 0;
    for (ItemModel item in _items) {
      qty += item.qty;
    }
    return qty;
  }

  int get totalItemsAmount {
    int total = 0;
    for (ItemModel item in _items) {
      total += (item.price.round() * item.qty);
    }
    return total;
  }

  Future<void> _onItemAdd(
    CartEventAddItem event,
    Emitter<CartState> emit,
  ) async {
    emit(CartStateLoading());
    _items.add(event.item);
    emit(CartStateAddItemSuccess());
  }
}
