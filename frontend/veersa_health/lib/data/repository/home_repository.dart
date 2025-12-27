import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:veersa_health/data/service/api_service.dart';
import 'package:veersa_health/features/home/models/doctor_model.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();

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

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.subLocality}, ${place.locality}";
      }
      return "Unknown Location";
    } catch (e) {
      return "Failed to get address";
    }
  }

  Future<List<DoctorModel>> getNearbyDoctors(
    double userLat,
    double userLng, {
    String? specialty,
  }) async {
    try {
      final allDoctors = await getAllDoctors(page: 0, size: 50);

      for (var doctor in allDoctors) {
        double distanceInMeters = Geolocator.distanceBetween(
          userLat,
          userLng,
          doctor.latitude,
          doctor.longitude,
        );
        doctor.distanceInKm = distanceInMeters / 1000;
      }

      List<DoctorModel> filteredList = allDoctors;
      if (specialty != null && specialty.isNotEmpty) {
        filteredList = allDoctors
            .where((d) => d.specialty.toLowerCase() == specialty.toLowerCase())
            .toList();
      }

      filteredList.sort((a, b) => a.distanceInKm.compareTo(b.distanceInKm));

      return filteredList;
    } catch (e) {
      throw "Error calculating nearby doctors: $e";
    }
  }

  Future<List<DoctorModel>> searchDoctors({
    required double latitude,
    required double longitude,
    required double maxDistanceKm,
    String? specialty,
  }) async {
    try {
      if (latitude == 0.0 || longitude == 0.0) {
        throw "Invalid location coordinates";
      }

      final Map<String, dynamic> queryParams = {
        'latitude': latitude,
        'longitude': longitude,
        'maxDistanceKm': maxDistanceKm,
      };

      if (specialty != null && specialty.isNotEmpty) {
        queryParams['specialty'] = specialty;
      }

      final response = await _apiService.get(
        '/api/doctors/search',
        params: queryParams,
      );

      List<dynamic> data;
      if (response.data is List) {
        data = response.data;
      } else if (response.data != null && response.data['data'] is List) {
        data = response.data['data'];
      } else {
        data = [];
      }

      return data.map((json) => DoctorModel.fromJson(json)).toList();
    } catch (e) {
      throw "Error searching doctors: $e";
    }
  }

  Future<List<DoctorModel>> getAllDoctors({int page = 0, int size = 10}) async {
    try {
      final response = await _apiService.get(
        '/api/doctors/all',
        params: {'page': page, 'size': size},
      );

      List<dynamic> data;
      if (response.data is List) {
        data = response.data;
      } else if (response.data['data'] is List) {
        data = response.data['data'];
      } else {
        data = [];
      }

      return data.map((json) => DoctorModel.fromJson(json)).toList();
    } catch (e) {
      throw "Error fetching doctors: $e";
    }
  }

  Future<List<AppointmentModel>> getMyAppointments(
    double lat,
    double lng,
  ) async {
    try {
      final response = await _apiService.get(
        '/api/appointments/my',
        params: {'latitude': lat, 'longitude': lng},
      );

      List<dynamic> data;

      if (response.data is List) {
        data = response.data;
      } else if (response.data != null && response.data['data'] is List) {
        data = response.data['data'];
      } else {
        data = [];
      }

      return data.map((json) => AppointmentModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
