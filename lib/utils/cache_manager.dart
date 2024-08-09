import 'package:apos_app/lib_exp.dart';

class CacheManager {
  static List<CategoryModel> categories = [];
  static List<ProductModel> products = [];
  static List<OrderModel> orders = [];

  static void clear() {
    categories.clear();
    products.clear();
    orders.clear();
  }
}
