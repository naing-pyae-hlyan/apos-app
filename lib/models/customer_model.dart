class CustomerModel {
  String? id;
  final String readableId;
  final String name;
  final String email;
  final String phone;
  final String? password;
  final String address;

  CustomerModel({
    this.id,
    required this.readableId,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json, String? id) {
    return CustomerModel(
      id: id,
      readableId: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      address: json['address'],
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
    };
  }
}
