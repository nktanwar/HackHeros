import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:veersa_health/features/home/models/doctor_model.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/schedule_appointment_screen.dart';

class DoctorDetailController extends GetxController {
  final doctorData = Rxn<DoctorModel>();
  String get doctorName => doctorData.value?.clinicName ?? "Doctor";
  String get specialty => doctorData.value?.specialty ?? "Specialist";
  String get distance => "${doctorData.value?.distanceInKm ?? 0} km";

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is DoctorModel) {
      doctorData.value = Get.arguments;
    }
  }

  void shareProfile() {
    if (doctorData.value == null) return;
    Share.share("Check out $doctorName. Book via Veersa Health!");
  }

  void navigateToBooking() {
    if (doctorData.value != null) {
      Get.to(
        () => const ScheduleAppointmentScreen(),
        arguments: {'doctorId': doctorData.value!.doctorId},
      );
    }
  }
}