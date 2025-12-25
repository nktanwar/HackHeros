import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observables
  var currentLocation = "Huda Panipat, Haryana".obs;
  var isFetchingLocation = false.obs;

  // Simulate fetching location
  Future<void> refreshLocation() async {
    isFetchingLocation.value = true;
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Update state
    currentLocation.value = "H.No 12, Model Town, Panipat";
    isFetchingLocation.value = false;
  }
}