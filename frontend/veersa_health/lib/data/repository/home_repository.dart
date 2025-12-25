import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:veersa_health/data/service/api_service.dart';
import 'package:veersa_health/features/home/models/doctor_model.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();

  // 1. Get Current Position
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // 2. Convert to Address (Reverse Geocoding)
  Future<String> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Format: Street, SubLocality, Locality
        return "${place.street}, ${place.subLocality}, ${place.locality}"; 
      }
      return "Unknown Location";
    } catch (e) {
      return "Failed to get address";
    }
  }

  // 3. Fetch Nearby Doctors (Using Real API)
  Future<List<DoctorModel>> getNearbyDoctors(double lat, double lng, {String? specialty}) async {
    try {
      final response = await _apiService.get(
        '/api/doctors/search',
        params: {
          'latitude': lat,
          'longitude': lng,
          if(specialty != null) 'specialty': specialty
        },
      );
      
      List<dynamic> data = response.data;
      return data.map((json) => DoctorModel.fromJson(json)).toList();
    } catch (e) {
      throw "Error fetching doctors: $e";
    }
  }

  // 4. Fetch Appointments (Using Real API)
  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      final response = await _apiService.get('/api/appointments/my');
      List<dynamic> data = response.data;
      return data.map((json) => AppointmentModel.fromJson(json)).toList();
    } catch (e) {
      throw "Error fetching appointments: $e";
    }
  }
}