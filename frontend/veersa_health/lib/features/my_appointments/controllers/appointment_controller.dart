import 'package:get/get.dart';
import 'package:veersa_health/data/repository/appointment_repository.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';
import 'package:veersa_health/features/my_appointments/models/slot_model.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/booking_success_screen.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/popups/full_screen_loader.dart';

class AppointmentController extends GetxController {
  static AppointmentController get instance => Get.find();
  final _repo = Get.put(AppointmentRepository());

  // --- MY APPOINTMENTS STATE ---
  var isLoading = true.obs;
  var selectedTab = 0.obs; // 0 = Upcoming, 1 = Previous
  var upcomingAppointments = <AppointmentModel>[].obs;
  var previousAppointments = <AppointmentModel>[].obs;

  // --- BOOKING STATE ---
  var isSlotsLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var bookingDoctorId = ''.obs; // To know which doctor we are booking
  
  // We store the full SlotModel because we need both startTime and endTime for the API
  var selectedSlot = Rxn<SlotModel>(); 
  var availableSlots = <SlotModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }

  // 1. Fetch & Sort Appointments
  void fetchAppointments() async {
    try {
      isLoading.value = true;
      final allAppointments = await _repo.getMyAppointments();
      
      final now = DateTime.now();

      // Logic: Filter based on start time vs Now
      upcomingAppointments.value = allAppointments.where((appt) {
        return appt.startTime.isAfter(now) && appt.status != AppointmentStatus.CANCELLED;
      }).toList();
      
      // Sort upcoming: Nearest first
      upcomingAppointments.sort((a, b) => a.startTime.compareTo(b.startTime));

      previousAppointments.value = allAppointments.where((appt) {
        return appt.startTime.isBefore(now) || appt.status == AppointmentStatus.COMPLETED;
      }).toList();
      
      // Sort previous: Newest first
      previousAppointments.sort((a, b) => b.startTime.compareTo(a.startTime));

    } catch (e) {
      CustomLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- BOOKING LOGIC ---

  // Called when entering the Schedule Screen
  void initBooking(String doctorId) {
    bookingDoctorId.value = doctorId;
    selectedDate.value = DateTime.now();
    selectedSlot.value = null;
    fetchSlotsForDate(DateTime.now());
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    selectedSlot.value = null; // Clear previous selection
    fetchSlotsForDate(date);
  }

  void selectSlot(SlotModel slot) {
    selectedSlot.value = slot;
  }

  // 2. Fetch Slots from Backend
  void fetchSlotsForDate(DateTime date) async {
    if (bookingDoctorId.value.isEmpty) return;

    try {
      isSlotsLoading.value = true;
      availableSlots.clear();
      
      final slots = await _repo.getDoctorSlots(bookingDoctorId.value, date);
      availableSlots.assignAll(slots);
      
    } catch (e) {
      CustomLoaders.errorSnackBar(title: "Slots Error", message: e.toString());
    } finally {
      isSlotsLoading.value = false;
    }
  }

  // 3. Confirm Booking
  void confirmAppointment() async {
    if (selectedSlot.value == null) {
      CustomLoaders.warningSnackBar(
        title: "Select Time", 
        message: "Please select a time slot to proceed."
      );
      return;
    }

    try {
      CustomFullScreenLoader.openLoadingDialog(
        "Booking appointment...",
        ImageStringsConstants.loadingImage, 
      );

      await _repo.bookAppointment(
        bookingDoctorId.value, 
        selectedSlot.value!.startTime, 
        selectedSlot.value!.endTime
      );

      CustomFullScreenLoader.closeLoadingDialog();
      
      // Refresh list for when we return to home
      fetchAppointments();
      
      Get.off(() => const BookingSuccessScreen());

    } catch (e) {
      CustomFullScreenLoader.closeLoadingDialog();
      CustomLoaders.errorSnackBar(title: "Booking Failed", message: e.toString());
    }
  }
}