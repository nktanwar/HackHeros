import 'package:veersa_health/utils/constants/image_string_constants.dart';

class DoctorModel {
  final String doctorId;
  final String clinicName;
  final String specialty;
  final double distanceInKm;

 
  final String image; 
  final double fees;

  DoctorModel({
    required this.doctorId,
    required this.clinicName,
    required this.specialty,
    required this.distanceInKm,
    this.image = ImageStringsConstants.onBoardingImage1,
    this.fees = 500.0,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      doctorId: json['doctorId'] ?? '',
      clinicName: json['clinicName'] ?? 'Unknown Clinic',
      specialty: json['specialty'] ?? 'General',
      distanceInKm: (json['distanceInKm'] ?? 0).toDouble(),
    );
  }
}