import 'package:apos_app/lib_exp.dart';

class DbBloc extends Bloc<DbEvent, DbState> {
  DbBloc() : super(DbStateInitial()) {
    on<DbEventGetProductsWithCategoryFromServer>(
        _getProductsWithCategoryFromServer);
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
}
