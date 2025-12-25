import 'package:get/get.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';

class AppointmentController extends GetxController {
  // Observables
  var isLoading = true.obs;
  var selectedTab = 0.obs; // 0 = Upcoming, 1 = Previous
  var upcomingAppointments = <Appointment>[].obs;
  var previousAppointments = <Appointment>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }

  // Simulate Backend Call
  void fetchAppointments() async {
    isLoading.value = true;
    
    // START BACKEND INTEGRATION POINT
    // await Future.delayed(Duration(seconds: 2)); 
    // var response = await http.get('api/appointments');
    // var data = jsonDecode(response.body);
    // END BACKEND INTEGRATION POINT

    // Dummy Data mimicking your image
    await Future.delayed(const Duration(seconds: 1)); // Mock network delay

    var dummyUpcoming = [
      Appointment(
        id: '1',
        doctorName: 'Dr. Priya Sharma',
        specialty: 'Cardiologist',
        doctorImageUrl: 'https://i.pravatar.cc/150?img=5', 
        phoneNumber: '+91 9876543210',
        appointmentDate: DateTime(2026, 4, 24, 15, 30),
        clinicName: 'HeartCare Clinic',
        address: '123 Health St, Suite 45, City, State, 560091',
        status: AppointmentStatus.upcoming,
      ),
    ];

    var dummyPrevious = [
      Appointment(
        id: '2',
        doctorName: 'Dr. Arjun Kapoor',
        specialty: 'General Physician',
        doctorImageUrl: 'https://i.pravatar.cc/150?img=11',
        phoneNumber: '+91 9876543210',
        appointmentDate: DateTime(2026, 4, 20, 9, 00),
        clinicName: 'City Health Center',
        address: '456 Wellness Ave, Suite 12',
        status: AppointmentStatus.completed,
      ),
       Appointment(
        id: '3',
        doctorName: 'Dr. Anjali Verma',
        specialty: 'Dentist',
        doctorImageUrl: 'https://i.pravatar.cc/150?img=9',
        phoneNumber: '+91 9876543210',
        appointmentDate: DateTime(2026, 4, 15, 14, 00),
        clinicName: 'Smile Dental Care',
        address: '789 Maple St',
        status: AppointmentStatus.completed,
      ),
      Appointment(
        id: '4',
        doctorName: 'Dr. Sameer Reddy',
        specialty: 'Dermatologist',
        doctorImageUrl: 'https://i.pravatar.cc/150?img=3',
        phoneNumber: '+91 9876543210',
        appointmentDate: DateTime(2026, 4, 10, 11, 15),
        clinicName: 'Clear Skin Clinic',
        address: '101 Main St, Suite 5',
        status: AppointmentStatus.completed,
      ),
    ];

    upcomingAppointments.assignAll(dummyUpcoming);
    previousAppointments.assignAll(dummyPrevious);
    isLoading.value = false;
  }
}