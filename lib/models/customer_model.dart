import 'package:apos_app/lib_exp.dart';

class Customer {
  String? id;
  final String readableId;
  final String name;
  final String email;
  final String phone;
  final String address;

  Customer({
    this.id,
    required this.readableId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json, String id) {
    return Customer(
      id: id,
      readableId: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': readableId,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}

Customer tempCustomer(int index) => Customer(
      id: "#$index",
      readableId: "",
      name: "Client ${Consts.aToz[index]}",
      email: "mail@example.com",
      phone: "09123456789",
      address: "Enim excepteur anim nostrud consequat.",
    );
