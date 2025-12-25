enum AppointmentStatus { upcoming, completed, cancelled }

class Appointment {
  final String id;
  final String doctorName;
  final String specialty;
  final String doctorImageUrl; 
  final String phoneNumber;
  final DateTime appointmentDate;
  final String clinicName;
  final String address;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.doctorImageUrl,
    required this.phoneNumber,
    required this.appointmentDate,
    required this.clinicName,
    required this.address,
    required this.status,
  });

  
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorName: json['doctor_name'],
      specialty: json['specialty'],
      doctorImageUrl: json['image_url'],
      phoneNumber: json['phone'],
      appointmentDate: DateTime.parse(json['date']),
      clinicName: json['clinic_name'],
      address: json['address'],
      status: AppointmentStatus.values.byName(json['status']),
    );
  }
}