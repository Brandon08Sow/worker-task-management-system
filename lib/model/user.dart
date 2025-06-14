// lib/model/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
    id: j['id'].toString(),
    name: j['name'] ?? '',
    email: j['email'] ?? '',
    phone: j['phone'],
    address: j['address'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
  };
}
