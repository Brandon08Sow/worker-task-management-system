class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;

  User({this.id, this.name, this.email, this.phone, this.address});

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
