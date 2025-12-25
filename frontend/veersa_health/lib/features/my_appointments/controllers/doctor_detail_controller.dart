import 'package:get/get.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/schedule_appointment_screen.dart';

class DoctorDetailController extends GetxController {
  // Observables for Doctor Data
  final doctorName = "Dr. Priya Sharma".obs;
  final speciality = "Cardiologist".obs;
  final experience = "12+ years of experience".obs;
  final bio = "Dr. Priya Sharma is a highly skilled cardiologist with over 12 years of experience in diagnosing and managing various heart conditions. She specializes in treating cardiovascular diseases such as coronary artery disease, heart failure, and arrhythmias.".obs;
  
  // Fees and Location
  final consultationFee = 80.obs; // Int for easy calculation later
  final distance = "800m".obs; // Distance tag as requested
  final clinicName = "HeartCare Clinic".obs;
  final address = "123 Health St, Suite 45, City, State, 560091".obs;

  // Actions
  void shareProfile() {
    // Add share logic here
    print("Profile Shared");
  }

void navigateToBooking() {
  Get.to(() => const ScheduleAppointmentScreen());
}
}