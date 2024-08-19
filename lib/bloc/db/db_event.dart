sealed class DbEvent {}

class DbEventGetProductsWithCategoryFromServer extends DbEvent {}

class DbEventUpdateFavItem extends DbEvent {
  final String categoryId;
  final String productId;
  final bool isFav;

  DbEventUpdateFavItem({
    required this.categoryId,
    required this.productId,
    required this.isFav,
  });
}
