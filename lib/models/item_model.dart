class ItemModel {
  String? id; // product_id
  final String name;
  final num price;
  List<String> types;
  List<int> colors;
  int qty;
  num totalAmount;

  ItemModel({
    this.id,
    required this.name,
    required this.price,
    required this.types,
    required this.colors,
    required this.qty,
    required this.totalAmount,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json, String id) => ItemModel(
        id: id,
        name: json["name"],
        price: json["price"],
        types:
            json["sizes"] == null ? [] : List.from(json["sizes"].map((x) => x)),
        colors: json["colors"] == null
            ? []
            : List.from(json["colors"].map((x) => x)),
        qty: json["qty"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "sizes": List.from(types.map((x) => x)),
        "colors": List.from(colors.map((x) => x)),
        "qty": qty,
        "total_amount": totalAmount,
      };
}
