class DoctorModel {
  final String doctorId;
  final String clinicName; 
  final String specialty;
  final String image;
  final double latitude;
  final double longitude;
  double distanceInKm; 

  DoctorModel({
    required this.doctorId,
    required this.clinicName,
    required this.specialty,
    required this.image,
    required this.latitude,
    required this.longitude,
    this.distanceInKm = 0.0,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      doctorId: json['_id'] ?? json['doctorId'] ?? '', 
      clinicName: json['clinicName'] ?? json['name'] ?? 'Unknown Clinic',
      specialty: json['specialty'] ?? 'General',
      image: json['image'] ?? 'assets/images/avatars/avatar3.png',
      latitude: (json['latitude'] is int)
          ? (json['latitude'] as int).toDouble()
          : (json['latitude'] as double?) ?? 0.0,
      longitude: (json['longitude'] is int)
          ? (json['longitude'] as int).toDouble()
          : (json['longitude'] as double?) ?? 0.0,
      
      distanceInKm: (json['distanceInKm'] is int)
          ? (json['distanceInKm'] as int).toDouble()
          : (json['distanceInKm'] as double?) ?? 0.0,
    );
  }
  
  bool get isNetworkImage => image.startsWith('http');
}