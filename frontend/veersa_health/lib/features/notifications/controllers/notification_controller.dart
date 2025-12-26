import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veersa_health/data/repository/notification_repository.dart';
import 'package:intl/intl.dart';
import 'package:veersa_health/features/notifications/models/notificaton_model.dart';

class NotificationController extends GetxController {
  final _repo = Get.put(NotificationRepository());

  var notifications = <NotificationModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final list = await _repo.getMyNotifications();

      list.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
      notifications.assignAll(list);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> launchMap(String? url) async {
    if (url != null && url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not open map.");
      }
    }
  }

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
    switch (model.type) {
      case NotificationType.APPOINTMENT_CONFIRMATION:
        return "Your appointment has been successfully booked. Ref ID: ${model.appointmentId}";
      case NotificationType.APPOINTMENT_REMINDER:
        return "This is a reminder for your appointment scheduled soon. Tap below for directions.";
      default:
        return "You have a new update regarding your account.";
    }
  }

  String formatTime(DateTime time) {
    return DateFormat('MMM d, h:mm a').format(time);
  }
}
