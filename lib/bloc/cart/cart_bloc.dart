import 'package:apos_app/lib_exp.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartStateInitial()) {
    on<CartEventAddItem>(_onItemAdd);
    on<CartEventUpdateItem>(_onItemUpdate);
    on<CartEventChangeItemQty>(_onItemChangeQty);
    on<CartEventRemoveItem>(_onRemoveItem);
    on<CartEventResetItems>(_onItemsClear);
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

  Future<void> _onItemUpdate(
    CartEventUpdateItem event,
    Emitter<CartState> emit,
  ) async {
    emit(CartStateLoading());
    for (int i = 0, l = _items.length; i < l; i++) {
      if (event.item.id == _items[i].id) {
        _items[i] = event.item;
        break;
      }
    }
    emit(CartStateUpdateItemSuccess());
  }

  Future<void> _onItemChangeQty(
    CartEventChangeItemQty event,
    Emitter<CartState> emit,
  ) async {
    emit(CartStateLoading());
    for (ItemModel item in _items) {
      if (event.itemId == item.id) {
        item.qty = event.newQty;
        item.totalAmount = (item.price.round() * event.newQty);
        break;
      }
    }
    emit(CartStateEditChangeItemQtySuccess());
  }

  Future<void> _onRemoveItem(
    CartEventRemoveItem event,
    Emitter<CartState> emit,
  ) async {
    emit(CartStateLoading());
    _items.removeWhere((ItemModel item) => item.id == event.itemId);
    emit(CartStateRemoveItemSuccess());
  }

  Future<void> _onItemsClear(
    CartEventResetItems event,
    Emitter<CartState> emit,
  ) async {
    _items.clear();
    emit(CartStateRemoveItemSuccess());
  }
}
