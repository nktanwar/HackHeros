import 'package:veersa_health/utils/constants/image_string_constants.dart';

enum AppointmentStatus { BOOKED, COMPLETED, CANCELLED }

class AppointmentModel {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime startTime;
  final DateTime endTime;
  final AppointmentStatus status;

  final String doctorName;
  final String clinicName;
  final String address;
  final String doctorImage;
  final String specialty;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.doctorName = "Dr. Veersa Specialist",
    this.clinicName = "Veersa Health Clinic",
    this.address = "123 Health St, Panipat",
    this.doctorImage = ImageStringsConstants.avatar3,
    this.specialty = "General Physician",
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      patientId: json['patientId'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: _parseStatus(json['status']),
    );
  }

  static AppointmentStatus _parseStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'COMPLETED':
        return AppointmentStatus.COMPLETED;
      case 'CANCELLED':
        return AppointmentStatus.CANCELLED;
      default:
        return AppointmentStatus.BOOKED;
    }
  }
}
