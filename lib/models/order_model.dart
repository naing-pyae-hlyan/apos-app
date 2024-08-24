import 'package:apos_app/lib_exp.dart';

class OrderModel {
  String? id;
  final String readableId;
  final CustomerModel customer;
  final List<ItemModel> items;

  final num totalAmount;
  final int statusId;
  final DateTime orderDate;
  final String comment;
  final String payment;
  final String? paymentSS;

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
    required this.payment,
    required this.paymentSS,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String id) {
    final Timestamp timestamp = json["order_date"];
    return OrderModel(
      id: id,
      readableId: json["id"],
      customer: CustomerModel.fromJson(json["customer"], null),
      items: List.from(json["items"].map((x) => ItemModel.fromJson(x))),
      orderDate: timestamp.toDate(),
      totalAmount: json['total_amount'],
      statusId: json['status_id'],
      status: parseToOrderStatusForMobileUI(json["status_id"]),
      comment: json["comment"],
      payment: json["payment"] ?? "CASH",
      paymentSS: json["payment_ss"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': readableId,
      'customer': customer.toJson(),
      'items': List.from(items.map((x) => x.toJson())),
      'order_date': orderDate,
      'total_amount': totalAmount,
      'status_id': statusId,
      'comment': comment,
      'payment': payment,
      'payment_ss': paymentSS,
    };
  }
}
