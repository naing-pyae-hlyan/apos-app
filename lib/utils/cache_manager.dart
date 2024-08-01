import 'package:apos_app/lib_exp.dart';

class CacheManager {
  static List<Category> categories = [];
  static List<Product> products = [];
  static List<Order> orders = [];

  static void clear() {
    categories.clear();
    products.clear();
    orders.clear();
  }
}
