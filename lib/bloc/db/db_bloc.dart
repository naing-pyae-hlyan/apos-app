import 'package:apos_app/lib_exp.dart';

class DbBloc extends Bloc<DbEvent, DbState> {
  DbBloc() : super(DbStateInitial()) {
    on<DbEventGetProductsWithCategoryFromServer>(
      _getProductsWithCategoryFromServer,
    );
    on<DbEventUpdateFavItem>(_updateFavItem);
  }

  Future<void> _getProductsWithCategoryFromServer(
    DbEventGetProductsWithCategoryFromServer event,
    Emitter<DbState> emit,
  ) async {
    emit(DbStateLoading());
    await FFirestoreUtils.categoryCollection.get().then(
      (QuerySnapshot<CategoryModel> snapshot) async {
        CacheManager.categories.clear();
        for (var doc in snapshot.docs) {
          CacheManager.categories.add(doc.data());
        }
        await FFirestoreUtils.productCollection.get().then(
          (QuerySnapshot<ProductModel> snapshot2) {
            CacheManager.products.clear();
            for (var doc in snapshot2.docs) {
              CacheManager.products.add(doc.data());
            }
            emit(DbStateGetProductsWithCategoryFromServerSuccess());
          },
        ).catchError(
          (error) {
            emit(DbStateFail(
              error: ErrorModel(message: error.toString(), code: 2),
            ));
          },
        );
      },
    ).catchError(
      (error) {
        emit(DbStateFail(
          error: ErrorModel(message: error.toString(), code: 1),
        ));
      },
    );
  }

  Future<void> _updateFavItem(
    DbEventUpdateFavItem event,
    Emitter<DbState> emit,
  ) async {
    emit(DbStateLoading());
    await SpHelper.favItems.then(
      (Map<String, List<String>> favs) async {
        var cached = favs;

        // Doesn't exist
        if (cached[event.categoryId] == null) {
          cached[event.categoryId] = [event.productId];
        } else {
          List<String> products = cached[event.categoryId] ?? [];

          if (products.isEmpty) {
            cached[event.categoryId] = [event.productId];
          } else if (event.isFav) {
            (cached[event.categoryId] ?? []).add(event.productId);
          } else {
            // products isNotEmpty && isNotFav
            products.removeWhere((String id) => id == event.productId);
            cached[event.categoryId] = [];
            cached[event.categoryId]!.addAll(products);
          }
        }

        await SpHelper.setFavItems(cached).then(
          (_) => emit(DbStateUpdateFavItemSuccess()),
        );
      },
    );
  }
}
