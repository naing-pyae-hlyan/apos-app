import 'package:apos_app/lib_exp.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemStateInitial()) {
    on<ItemEventGetProductsWithCategory>(_getProductsWithCategory);
  }

  Future<void> _getProductsWithCategory(
    ItemEventGetProductsWithCategory event,
    Emitter<ItemState> emit,
  ) async {
    emit(ItemStateLoading());
    await FFirestoreUtils.categoryCollection.get().then(
      (QuerySnapshot<Category> snapshot) async {
        CacheManager.categories.clear();
        for (var doc in snapshot.docs) {
          CacheManager.categories.add(doc.data());
        }
        await FFirestoreUtils.productCollection.get().then(
          (QuerySnapshot<Product> snapshot2) {
            CacheManager.products.clear();
            for (var doc in snapshot2.docs) {
              CacheManager.products.add(doc.data());
            }
            emit(ItemStateSuccess());
          },
        ).catchError(
          (error) {
            emit(ItemStateFail(
              error: ErrorModel(message: error.toString(), code: 2),
            ));
          },
        );
      },
    ).catchError(
      (error) {
        emit(ItemStateFail(
          error: ErrorModel(message: error.toString(), code: 1),
        ));
      },
    );
  }
}
