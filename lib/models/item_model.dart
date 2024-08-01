import 'dart:math';
import 'package:apos_app/lib_exp.dart';


class Item {
  String? id;
  final String readableId;
  final String name;
  final double amount;
  final double discount;
  final int quantity;

  Item({
    this.id,
    required this.readableId,
    required this.name,
    required this.amount,
    required this.discount,
    required this.quantity,
  });

  factory Item.fromJson(Map<String, dynamic> json, String id) => Item(
        id: id,
        readableId: json['id'],
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

Item tempItem(int index) => Item(
      id: "#$index",
      readableId: "",
      name: "Item ${Consts.aToz[index]}",
      amount: Random().nextInt(1000) + 10000,
      discount: 0.0,
      quantity: Random().nextInt(1000),
    );
