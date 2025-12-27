import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veersa_health/data/repository/appointment_repository.dart';
import 'package:veersa_health/data/repository/home_repository.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';
import 'package:veersa_health/features/my_appointments/models/slot_model.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/booking_success_screen.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/loaders/full_screen_loader.dart';

class AppointmentController extends GetxController {
  static AppointmentController get instance => Get.find();

  final _apptRepo = Get.put(AppointmentRepository());
  final _homeRepo = HomeRepository();

  var isLoading = true.obs;
  var selectedTab = 0.obs;
  var invalidSlots = <DateTime>[].obs;
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

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _loadAppointments(0.0, 0.0);
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        CustomLoaders.warningSnackBar(
          title: "Permission Required",
          message: "Enable location in settings to see distance.",
        );
        _loadAppointments(0.0, 0.0);
        isLoading.value = false;
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _loadAppointments(position.latitude, position.longitude);
    } catch (e) {
      CustomLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadAppointments(double lat, double lng) async {
    final allAppointments = await _homeRepo.getMyAppointments(lat, lng);
    final now = DateTime.now();

    upcomingAppointments.value = allAppointments.where((appt) {
      final isFutureStart = appt.startTime.isAfter(now);
      final isActiveStatus =
          appt.status != AppointmentStatus.CANCELLED &&
          appt.status != AppointmentStatus.COMPLETED;
      return isFutureStart && isActiveStatus;
    }).toList();

    upcomingAppointments.sort((a, b) => a.startTime.compareTo(b.startTime));

    previousAppointments.value = allAppointments.where((appt) {
      final isStarted = appt.startTime.isBefore(now);
      final isCompletedOrCancelled =
          appt.status == AppointmentStatus.COMPLETED ||
          appt.status == AppointmentStatus.CANCELLED;

      return isStarted || isCompletedOrCancelled;
    }).toList();

    previousAppointments.sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  Future<void> launchMapUrl(String url) async {
    if (url.isEmpty) {
      CustomLoaders.warningSnackBar(
        title: "Location Missing",
        message: "No map location available for this clinic.",
      );
      return;
    }

    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        CustomLoaders.errorSnackBar(
          title: "Could not open map",
          message: "Could not launch the map application.",
        );
      }
    } catch (e) {
      CustomLoaders.errorSnackBar(
        title: "Error",
        message: "Invalid map URL provided.",
      );
      debugPrint("Map Launch Error: $e");
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
      invalidSlots.clear();

      final slots = await _apptRepo.getDoctorSlots(bookingDoctorId.value, date);
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

      await _apptRepo.bookAppointment(
        bookingDoctorId.value,
        selectedSlot.value!.startTime,
        selectedSlot.value!.endTime,
      );

      CustomFullScreenLoader.closeLoadingDialog();

      fetchAppointments();

      Get.off(() => const BookingSuccessScreen());
    } catch (e) {
      if (e.toString().contains("already booked")) {
        invalidSlots.add(selectedSlot.value!.startTime);

        selectedSlot.value = null;

        CustomLoaders.warningSnackBar(
          title: "Slot Unavailable",
          message: "That slot was just taken! It has been disabled.",
        );
      } else {
        CustomLoaders.errorSnackBar(
          title: "Booking Failed",
          message: e.toString(),
        );
      }
    }
  }
}
