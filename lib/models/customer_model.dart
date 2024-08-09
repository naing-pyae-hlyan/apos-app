import 'package:apos_app/lib_exp.dart';

class CustomerModel {
  String? id;
  final String readableId;
  final String name;
  final String email;
  final String phone;
  final String address;

  CustomerModel({
    this.id,
    required this.readableId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json, String id) {
    return CustomerModel(
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

CustomerModel tempCustomer(int index) => CustomerModel(
      id: "#$index",
      readableId: "",
      name: "Client ${Consts.aToz[index]}",
      email: "mail@example.com",
      phone: "09123456789",
      address: "Enim excepteur anim nostrud consequat.",
    );
