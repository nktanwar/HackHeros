class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };
}

class LoginResponse {
  final String accessToken; 
  final String tokenType;   
  final int expiresIn;      

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '', 
      tokenType: json['tokenType'] ?? 'Bearer',
      expiresIn: json['expiresIn'] ?? 0,
    );
  }
}

class SignupRequest {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String role; 
  final String? specialty; 
  final double latitude;
  final double longitude;

  SignupRequest({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.role = "PATIENT",
    this.specialty,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phoneNumber": phoneNumber,
    "password": password,
    "role": role,
    "specialty": specialty,
    "latitude": latitude,
    "longitude": longitude,
  };
}