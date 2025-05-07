class Worker {
  String? workerId;
  String? fullName;
  String? email;
  String? phone;
  String? address;

  Worker({this.workerId, this.fullName, this.email, this.phone, this.address});

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      workerId: json['id'].toString(),
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  static String hashPassword(String password) {
    // SHA1 hashing is handled in PHP backend
    return password;
  }
}
