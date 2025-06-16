class User {
  final String id;
  final String fullname;
  final String email;
  final String? phone;
  final String? address;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    this.phone,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
    id: j['id'].toString(),
    fullname: j['full_name'] ?? '',
    email: j['email'] ?? '',
    phone: j['phone'],
    address: j['address'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullname,
    "email": email,
    "phone": phone,
    "address": address,
  };
}
