import 'dart:math';
import 'package:apos_app/lib_exp.dart';


class Order {
  String? id;
  final String readableId;
  final Customer customer;
  final List<Item> items;

  final double totalAmount;
  final int statusId;
  final DateTime orderDate;
  final String comment;

  OrderStatus status;

  Order({
    this.id,
    required this.readableId,
    required this.customer,
    required this.items,
    required this.orderDate,
    required this.totalAmount,
    required this.statusId,
    required this.status,
    required this.comment,
  });

  factory Order.fromJson(Map<String, dynamic> json, String id) {
    return Order(
      id: id,
      readableId: json["id"],
      customer: Customer.fromJson(json["customer"], "TODO"),
      items: List.from(json["items"].map((x) => Item.fromJson(x, "TODO"))),
      orderDate: DateTime.parse(json['order_date']),
      totalAmount: json['total_amount'],
      statusId: json['status_id'],
      status: parseToOrderStatus(json["status_id"]),
      comment: json["comment"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': readableId,
      'customer': customer.toJson(),
      'items': List.from(items.map((x) => x)),
      'order_date': orderDate.toIso8601String(),
      'total_amount': totalAmount,
      'status_id': statusId,
      'comment': comment,
    };
  }
}

Order tempOrder(int index) {
  final statusId = Random().nextInt(4);
  return Order(
    id: "#$index",
    readableId: "",
    customer: tempCustomer(index),
    items: List.generate(
      Random().nextInt(8) + 2,
      (i) => tempItem(i),
    ),
    orderDate: DateTime.now(),
    totalAmount: Random().nextInt(1000) + 10000,
    statusId: statusId,
    status: parseToOrderStatus(statusId),
    comment:
        "Cupidatat tempor ullamco anim dolore aliqua ipsum minim nostrud duis dolor occaecat et qui.",
  );
}
