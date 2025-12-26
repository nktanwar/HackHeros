class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final bool verified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.verified,
  });

  // Factory method to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? 'PATIENT',
      verified: json['verified'] ?? false,
    );
  }

  // Empty state for initialization
  static UserModel empty() => UserModel(
        id: '',
        name: '',
        email: '',
        phoneNumber: '',
        role: '',
        verified: false,
      );
}