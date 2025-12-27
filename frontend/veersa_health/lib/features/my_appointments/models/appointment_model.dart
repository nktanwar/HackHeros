import 'package:veersa_health/utils/constants/image_string_constants.dart';

enum AppointmentStatus { BOOKED, COMPLETED, CANCELLED }

class AppointmentModel {
  final String appointmentId;
  final String doctorId;
  final String? patientId;
  final DateTime startTime;
  final DateTime endTime;
  final AppointmentStatus status;
  final String doctorName;
  final String doctorImage;
  final String specialty;
  final String clinicName;
  final String mapUrl;
  final double distanceInKm;

  AppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    this.patientId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.doctorName,
    required this.specialty,
    required this.clinicName,
    required this.mapUrl,
    this.distanceInKm = 0.0,
    this.doctorImage = ImageStringsConstants.avatar3,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentId: json['appointmentId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      patientId: json['patientId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: _parseStatus(json['status']),
      doctorName: json['doctorName'] ?? 'Unknown Doctor',
      specialty: json['specialty'] ?? 'General',
      clinicName: json['clinicName'] ?? 'Unknown Clinic',
      mapUrl: json['mapUrl'] ?? '',

      distanceInKm: (json['distanceInKm'] ?? 0).toDouble(),
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
