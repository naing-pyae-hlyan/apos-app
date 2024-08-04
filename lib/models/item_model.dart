import 'package:apos_app/lib_exp.dart';

class Item {
  String? id;
  final String readableId;
  final String name;
  final double price;
  final double totalPrice;
  final int qty;
  final String? categoryId;
  final String? categoryName;

  Item({
    this.id,
    required this.readableId,
    required this.name,
    required this.price,
    required this.totalPrice,
    required this.qty,
    required this.categoryId,
    required this.categoryName,
  });

  static Item addItem({
    required Product product,
    required int q,
    required double tp,
  }) =>
      Item(
        readableId: product.readableId,
        name: product.name,
        price: product.price,
        categoryId: product.categoryId,
        categoryName: product.categoryName,
        totalPrice: tp,
        qty: q,
      );

  factory Item.fromJson(Map<String, dynamic> json, String id) => Item(
        id: id,
        readableId: json['id'],
        name: json["name"],
        price: json["price"],
        totalPrice: json["total_price"],
        qty: json["qty"],
        categoryId: json['category_id'],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": readableId,
        "name": name,
        "price": price,
        "total_price": totalPrice,
        "qty": qty,
        'category_id': categoryId,
        'category_name': categoryName,
      };
}
