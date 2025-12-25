class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;

  UserModel({required this.id, required this.fullName, required this.email, required this.phone});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone':phone,
    };
  }


  static UserModel empty() => UserModel(id: '', fullName: '', email: '', phone: '');

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json[''],
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone
    );
  }
}
