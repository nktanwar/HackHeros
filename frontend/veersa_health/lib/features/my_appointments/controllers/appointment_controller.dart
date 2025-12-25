import 'package:get/get.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/booking_success_screen.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/popups/full_screen_loader.dart';

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
    fetchSlotsForDate(DateTime.now()); // Load slots for today initially
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
        doctorImageUrl: ImageStringsConstants.avatar8, 
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
        doctorImageUrl: ImageStringsConstants.avatar3,
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
        doctorImageUrl: ImageStringsConstants.avatar3,
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
        doctorImageUrl: ImageStringsConstants.avatar7,
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

  var selectedDate = DateTime.now().obs;
  var selectedTimeSlot = ''.obs; 
  
  // Mock Database of Slots: Key = Date String, Value = List of Slots
  // In a real app, this comes from an API based on selectedDate
  final RxList<Map<String, dynamic>> availableSlots = <Map<String, dynamic>>[].obs;



  // --- Actions ---

  // 1. Handle Date Selection
  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    selectedTimeSlot.value = ''; // Reset slot selection
    fetchSlotsForDate(date);
  }

  // 2. Select a Time Slot
  void selectTimeSlot(String time) {
    selectedTimeSlot.value = time;
  }

  // 3. Confirm Booking
  void confirmAppointment() async {
    if (selectedTimeSlot.value.isEmpty) {
      CustomLoaders.warningSnackBar(
        title: "Select Time", 
        message: "Please select a time slot to proceed."
      );
      return;
    }

    // Start Loading
    CustomFullScreenLoader.openLoadingDialog(
      "Booking your appointment...",
      ImageStringsConstants.loadingImage,
    );

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));

    // Stop Loading
    CustomFullScreenLoader.closeLoadingDialog();

    // Navigate to Success
    Get.off(() => const BookingSuccessScreen());
  }

  // --- Helper: Mock Data Generator ---
  void fetchSlotsForDate(DateTime date) {
    // Simulating different slots for different days
    // Even days have morning slots full, Odd days have evening slots full
    bool isEvenDay = date.day % 2 == 0;

    availableSlots.value = [
      {'time': '09:00 AM', 'isAvailable': true},
      {'time': '10:00 AM', 'isAvailable': !isEvenDay}, // Full on even days
      {'time': '11:00 AM', 'isAvailable': true},
      {'time': '01:00 PM', 'isAvailable': false}, // Always full (Lunch)
      {'time': '02:00 PM', 'isAvailable': true},
      {'time': '03:00 PM', 'isAvailable': true},
      {'time': '04:00 PM', 'isAvailable': isEvenDay}, // Full on odd days
      {'time': '05:00 PM', 'isAvailable': true},
    ];
  }
}