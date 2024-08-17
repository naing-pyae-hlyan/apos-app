import 'package:apos_app/lib_exp.dart';

class CustomerModel {
  String? id;
  final String readableId;
  final String name;
  final String email;
  final String phone;
  final String? password;
  final String address;
  final int status;
  final String? fcmToken;
  final DateTime createdDate;
  // final Map<String, List<String>> favourites;

  CustomerModel({
    this.id,
    required this.readableId,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
    required this.status,
    required this.fcmToken,
    required this.createdDate,
    // required this.favourites,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json, String? id) {
    final Timestamp timestamp = json["created_date"];
    return CustomerModel(
      id: id,
      readableId: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      address: json['address'],
      status: json['status'] ?? 1,
      fcmToken: json['fcm_token'],
      createdDate: timestamp.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': readableId,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'address': address,
      'status': status,
      'fcm_token': fcmToken,
      'created_date': createdDate,
    };
  }
}
