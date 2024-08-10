import 'package:apos_app/lib_exp.dart';

class OrderModel {
  String? id;
  final String readableId;
  final CustomerModel customer;
  final List<ItemModel> items;

  final double totalAmount;
  final int statusId;
  final DateTime orderDate;
  final String comment;

  OrderStatus status;

  OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    return OrderModel(
      id: id,
      readableId: json["id"],
      customer: CustomerModel.fromJson(json["customer"], "TODO"),
      items: List.from(json["items"].map((x) => ItemModel.fromJson(x, "TODO"))),
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
