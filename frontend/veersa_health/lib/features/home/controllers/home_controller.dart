import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:veersa_health/data/repository/home_repository.dart';
import 'package:veersa_health/features/home/models/doctor_model.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  
  final _repo = HomeRepository();

  var address = "Fetching location...".obs;
  var isFetchingLocation = true.obs;
  var isDataLoading = false.obs;
  
  var nearbyDoctors = <DoctorModel>[].obs;
  var upcomingAppointments = <AppointmentModel>[].obs;

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
      
      Position pos = await _repo.getCurrentLocation();
      currentLat = pos.latitude;
      currentLng = pos.longitude;

      _repo.getAddressFromLatLng(pos).then((value) => address.value = value);

      await fetchDashboardData();

    } catch (e) {
      address.value = "Location Error";
      debugPrint("Location Error: $e");
    } finally {
      isFetchingLocation.value = false;
    }
  }

  Future<void> fetchDashboardData() async {
    if (currentLat == null || currentLng == null) return;
    
    isDataLoading.value = true;
    try {
      
      final results = await Future.wait([
        _repo.getNearbyDoctors(currentLat!, currentLng!),
        _repo.getMyAppointments(currentLat!, currentLng!), 
      ]);

      final doctors = results[0] as List<DoctorModel>;
      final myAppointments = results[1] as List<AppointmentModel>;

      nearbyDoctors.assignAll(doctors);
      
      
      final upcoming = myAppointments.where((appt) => 
          appt.startTime.isAfter(DateTime.now()) && 
          appt.status != AppointmentStatus.CANCELLED 
        ).toList();
        
      
      upcoming.sort((a, b) => a.startTime.compareTo(b.startTime));
      
      upcomingAppointments.assignAll(upcoming);

    } catch (e) {
      debugPrint("Error loading dashboard: $e");
    } finally {
      isDataLoading.value = false;
    }
  }

  
  Future<void> launchMapUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not launch map");
    }
  }
}