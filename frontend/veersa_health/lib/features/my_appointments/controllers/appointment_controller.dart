import 'package:get/get.dart';
import 'package:veersa_health/data/repository/appointment_repository.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';
import 'package:veersa_health/features/my_appointments/models/slot_model.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/booking_success_screen.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/loaders/full_screen_loader.dart';

class AppointmentController extends GetxController {
  static AppointmentController get instance => Get.find();
  final _repo = Get.put(AppointmentRepository());

  var isLoading = true.obs;
  var selectedTab = 0.obs;
  var upcomingAppointments = <AppointmentModel>[].obs;
  var previousAppointments = <AppointmentModel>[].obs;

  var isSlotsLoading = false.obs;
  var selectedDate = DateTime.now().obs;
  var bookingDoctorId = ''.obs;

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

  void fetchAppointments() async {
    try {
      isLoading.value = true;
      final allAppointments = await _repo.getMyAppointments();

      final now = DateTime.now();

      upcomingAppointments.value = allAppointments.where((appt) {
        return appt.startTime.isAfter(now) &&
            appt.status != AppointmentStatus.CANCELLED;
      }).toList();

      upcomingAppointments.sort((a, b) => a.startTime.compareTo(b.startTime));

      previousAppointments.value = allAppointments.where((appt) {
        return appt.startTime.isBefore(now) ||
            appt.status == AppointmentStatus.COMPLETED;
      }).toList();

      previousAppointments.sort((a, b) => b.startTime.compareTo(a.startTime));
    } catch (e) {
      CustomLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void initBooking(String doctorId) {
    bookingDoctorId.value = doctorId;
    selectedDate.value = DateTime.now();
    selectedSlot.value = null;
    fetchSlotsForDate(DateTime.now());
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    selectedSlot.value = null;
    fetchSlotsForDate(date);
  }

  void selectSlot(SlotModel slot) {
    selectedSlot.value = slot;
  }

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

  void confirmAppointment() async {
    if (selectedSlot.value == null) {
      CustomLoaders.warningSnackBar(
        title: "Select Time",
        message: "Please select a time slot to proceed.",
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
        selectedSlot.value!.endTime,
      );

      CustomFullScreenLoader.closeLoadingDialog();

      fetchAppointments();

      Get.off(() => const BookingSuccessScreen());
    } catch (e) {
      CustomFullScreenLoader.closeLoadingDialog();
      CustomLoaders.errorSnackBar(
        title: "Booking Failed",
        message: e.toString(),
      );
    }
  }
}
