import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart'; // Add share_plus to pubspec
import 'package:veersa_health/features/home/models/doctor_model.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/schedule_appointment_screen.dart';

class DoctorDetailController extends GetxController {
  // Observables
  final doctorData = Rxn<DoctorModel>();
  
  // Computed variables for UI
  String get doctorName => doctorData.value?.clinicName ?? "Doctor"; // Fallback as API gives clinicName
  String get specialty => doctorData.value?.specialty ?? "Specialist";
  String get address => "123 Health St, Suite 45"; // Mock address
  double get fees => doctorData.value?.fees ?? 500.0;
  String get distance => "${doctorData.value?.distanceInKm ?? 0} km";

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments is DoctorModel) {
      doctorData.value = Get.arguments;
    }
  }

  void shareProfile() {
    if(doctorData.value == null) return;
    Share.share("Check out $doctorName at $address. Book via Veersa Health!");
  }

  void navigateToBooking() {
    if(doctorData.value != null) {
      Get.to(
        () => const ScheduleAppointmentScreen(),
        // Pass Doctor ID for the Booking API
        arguments: {'doctorId': doctorData.value!.doctorId} 
      );
    }
  }
}