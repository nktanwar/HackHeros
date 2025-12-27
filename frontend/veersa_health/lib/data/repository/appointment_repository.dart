import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/data/service/api_service.dart';
import 'package:veersa_health/features/my_appointments/models/slot_model.dart';

class AppointmentRepository extends GetxService {
  static AppointmentRepository get instance => Get.find();
  final ApiService _apiService = ApiService();

  Future<List<SlotModel>> getDoctorSlots(String doctorId, DateTime date) async {
    try {
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

  Future<void> bookAppointment(
    String doctorId,
    DateTime startTime,
    DateTime endTime,
  ) async {
    try {
      await _apiService.post(
        '/api/appointments/book',
        data: {
          "doctorId": doctorId,
          "startTime": startTime.toUtc().toIso8601String(),
          "endTime": endTime.toUtc().toIso8601String(),
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        debugPrint("Error: $e");
        throw 'This time slot is already booked. Please select a different time.';
      } else if (e.response?.statusCode == 401) {
        debugPrint("Error: $e");
        throw 'You are not logged in.';
      }
      else {
        debugPrint("Error:================================= $e");
        throw 'Server error: ${e.response?.statusMessage ?? 'Unknown error'}';
      }
    } catch (e) {
        debugPrint("Error: $e");
      throw 'Connection failed. Please check your internet.';
    }
  }
}
