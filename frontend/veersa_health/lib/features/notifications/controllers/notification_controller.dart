import 'package:get/get.dart';
import 'package:veersa_health/data/repository/notification_repository.dart';
import 'package:intl/intl.dart';
import 'package:veersa_health/features/notifications/models/notificaton_model.dart';

class NotificationController extends GetxController {
  final _repo = Get.put(NotificationRepository());

  var notifications = <NotificationModel>[].obs;
  var isLoading = true.obs;

  // Since backend doesn't return 'isRead', we treat all fetched as read/history
  // or simple list. Separation logic removed as it was based on dummy data.
  
  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final list = await _repo.getMyNotifications();
      // Sort by newest first
      list.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
      notifications.assignAll(list);
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  // --- Helpers for UI (Deriving data from Type) ---
  
  String getTitle(NotificationModel model) {
    switch (model.type) {
      case NotificationType.APPOINTMENT_CONFIRMATION:
        return "Appointment Confirmed";
      case NotificationType.APPOINTMENT_REMINDER:
        return "Upcoming Appointment";
      default:
        return "Notification";
    }
  }

  String getDescription(NotificationModel model) {
    // Since backend doesn't give description, we generate generic text
    switch (model.type) {
      case NotificationType.APPOINTMENT_CONFIRMATION:
        return "Your appointment has been successfully booked. Ref ID: ${model.appointmentId}";
      case NotificationType.APPOINTMENT_REMINDER:
        return "This is a reminder for your appointment scheduled soon.";
      default:
        return "You have a new update regarding your account.";
    }
  }

  String formatTime(DateTime time) {
    return DateFormat('MMM d, h:mm a').format(time);
  }
}