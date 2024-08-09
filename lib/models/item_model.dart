import 'dart:math';

import 'package:apos_app/lib_exp.dart';

class ItemModel {
  String? id;
  final String readableId;
  final String name;
  final double amount;
  final double discount;
  final int quantity;

  ItemModel({
    this.id,
    required this.readableId,
    required this.name,
    required this.amount,
    required this.discount,
    required this.quantity,
  });

  // static ItemModel addItem({
  //   required ProductModel product,
  //   required int q,
  //   required double tp,
  // }) =>
  //     ItemModel(
  //       readableId: product.readableId,
  //       name: product.name,
  //       price: product.price,
  //       categoryId: product.categoryId,
  //       categoryName: product.categoryName,
  //       totalPrice: tp,
  //       qty: q,
  //     );

  factory ItemModel.fromJson(Map<String, dynamic> json, String id) => ItemModel(
        id: id,
        readableId: json["id"],
        name: json["name"],
        amount: json["amount"],
        discount: json["discount"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": readableId,
        "name": name,
        "amount": amount,
        "discount": discount,
        "quantity": quantity,
      };
}

ItemModel tempItem(int index) => ItemModel(
      id: "#$index",
      readableId: "",
      name: "Item ${Consts.aToz[index]}",
      amount: Random().nextInt(1000) + 10000,
      discount: 0.0,
      quantity: Random().nextInt(1000),
    );
