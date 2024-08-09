class ProductSizeModel {
  final String size;
  bool status;
  ProductSizeModel({required this.size, required this.status});

  // Just return the passed data
  static List<String> parseProductSizesToName(List<ProductSizeModel> sizes) {
    return sizes.map((ProductSizeModel ps) => ps.size).toList();
  }

  static List<ProductSizeModel> parseSizesToSelectedProductSizes(
      List<String> sizes) {
    sizes.removeWhere((String s) => s == "-");
    return sizes
        .map((String size) => ProductSizeModel(size: size, status: true))
        .toList();
  }

  static List<ProductSizeModel> parseSiezsToAllProductSizes({
    required List<String> sizes,
    required List<String> oldSizes,
  }) {
    sizes.removeWhere((String s) => s == "-" || s.isEmpty);
    oldSizes.removeWhere((String s) => s == "-" || s.isEmpty);
    final List<ProductSizeModel> result = [];
    for (String size in sizes) {
      bool status = false;
      for (String old in oldSizes) {
        if (old == size) {
          status = true;
          break;
        }
      }
      result.add(ProductSizeModel(size: size, status: status));
    }
    return result;
  }
}
