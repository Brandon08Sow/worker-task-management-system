class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
    );
  }
}
