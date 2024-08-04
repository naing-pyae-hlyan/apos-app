import 'package:apos_app/enum/product_colors.dart';

class Product {
  String? id;
  final String readableId;
  final String name;
  final List<String> base64Images;
  final String? description;
  final double price;
  final List<String> sizes;
  final List<int> hexColors;
  final String? categoryId;
  final String? categoryName;
  final int topSalesCount;

  //
  final List<ProductColors> productColorsEnum;
  int qty;
  double totalPrice;

  Product({
    this.id,
    required this.readableId,
    required this.name,
    required this.base64Images,
    required this.description,
    required this.price,
    required this.sizes,
    required this.hexColors,
    required this.categoryId,
    required this.categoryName,
    required this.topSalesCount,

    //
    required this.productColorsEnum,
    required this.qty,
    required this.totalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json, String docId) {
    return Product(
      id: docId,
      readableId: json["id"],
      name: json['name'],
      base64Images: List.from(json["images"].map((x) => x)),
      description: json['description'],
      price: (json['price'] as int).toDouble(),
      sizes:
          json['sizes'] == null ? [] : List.from(json['sizes'].map((x) => x)),
      hexColors:
          json['colors'] == null ? [] : List.from(json['colors'].map((x) => x)),
      categoryId: json['category_id'],
      categoryName: json["category_name"],
      topSalesCount: json["top_sales_count"] ?? 0,
      productColorsEnum: json['colors'] == null
          ? []
          : List.from(json['colors'].map((x) => parseHexToProductColor(x))),
      qty: 1,
      totalPrice: (json['price'] as int).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': readableId,
      'name': name,
      'images': List.from(base64Images.map((x) => x)),
      'description': description,
      'price': price,
      'sizes': List.from((sizes).map((x) => x)),
      'colors': List.from((hexColors).map((x) => x)),
      'category_id': categoryId,
      'category_name': categoryName,
      'top_sales_count': topSalesCount,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Product && id == other.id;
  }

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}
