import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:veersa_health/data/repository/home_repository.dart';
import 'package:veersa_health/features/home/models/doctor_model.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  
  final _repo = HomeRepository();

  // Observables
  var address = "Fetching location...".obs;
  var isFetchingLocation = true.obs;
  var isDataLoading = false.obs;
  
  var nearbyDoctors = <DoctorModel>[].obs;
  var upcomingAppointments = <AppointmentModel>[].obs;

  // Stored Coordinates for Search Screen use
  double? currentLat;
  double? currentLng;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      isFetchingLocation.value = true;
      
      // 1. Get Lat/Lng
      Position pos = await _repo.getCurrentLocation();
      currentLat = pos.latitude;
      currentLng = pos.longitude;

      // 2. Get Readable Address (Async)
      _repo.getAddressFromLatLng(pos).then((value) => address.value = value);

      // 3. Fetch Data based on location
      await fetchDashboardData();

    } catch (e) {
      address.value = "Location Error: Enable GPS";
      debugPrint("Location Error: $e");
    } finally {
      isFetchingLocation.value = false;
    }
  }

  Future<void> fetchDashboardData() async {
    if (currentLat == null) return;
    
    isDataLoading.value = true;
    try {
      // Parallel Execution for efficiency
      final results = await Future.wait([
        _repo.getNearbyDoctors(currentLat!, currentLng!),
        _repo.getMyAppointments(),
      ]);

      // Assign Doctors
      nearbyDoctors.assignAll(results[0] as List<DoctorModel>);

      // Filter Upcoming Appointments (Start Time > Now)
      List<AppointmentModel> allAppts = results[1] as List<AppointmentModel>;
      upcomingAppointments.assignAll(
        allAppts.where((appt) => 
          appt.startTime.isAfter(DateTime.now()) && 
          appt.status != 'CANCELLED'
        ).toList()
      );
      
      // Sort upcoming by soonest first
      upcomingAppointments.sort((a, b) => a.startTime.compareTo(b.startTime));

    } catch (e) {
      debugPrint("Error loading dashboard: $e");
    } finally {
      isDataLoading.value = false;
    }
  }
}