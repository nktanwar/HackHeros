import 'package:get/get.dart';
import 'package:veersa_health/data/service/api_service.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';
import 'package:veersa_health/features/my_appointments/models/slot_model.dart';

class AppointmentRepository extends GetxService {
  static AppointmentRepository get instance => Get.find();
  final ApiService _apiService = ApiService();

  // 1. Get My Appointments
  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      final response = await _apiService.get('/api/appointments/my');
      List<dynamic> data = response.data;
      return data.map((e) => AppointmentModel.fromJson(e)).toList();
    } catch (e) {
      throw 'Error fetching appointments: $e';
    }
  }

  // 2. Get Doctor Slots
  Future<List<SlotModel>> getDoctorSlots(String doctorId, DateTime date) async {
    try {
      // Calculate start and end of the selected day in UTC
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final response = await _apiService.get(
        '/api/doctors/$doctorId/slots',
        params: {
          'rangeStart': startOfDay.toUtc().toIso8601String(),
          'rangeEnd': endOfDay.toUtc().toIso8601String(),
        },
      );

      List<dynamic> data = response.data;
      return data.map((e) => SlotModel.fromJson(e)).toList();
    } catch (e) {
      throw 'Error fetching slots: $e';
    }
  }

  // 3. Book Appointment
  Future<void> bookAppointment(String doctorId, DateTime startTime, DateTime endTime) async {
    try {
      await _apiService.post(
        '/api/appointments/book',
        data: {
          "doctorId": doctorId,
          "startTime": startTime.toUtc().toIso8601String(),
          "endTime": endTime.toUtc().toIso8601String(),
        },
      );
    } catch (e) {
      throw 'Booking failed: $e';
    }
  }
}