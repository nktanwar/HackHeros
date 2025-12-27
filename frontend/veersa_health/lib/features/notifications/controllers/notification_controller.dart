import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veersa_health/data/repository/home_repository.dart';
import 'package:veersa_health/data/repository/notification_repository.dart';
import 'package:intl/intl.dart';
import 'package:veersa_health/features/notifications/models/notificaton_model.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();
  final _repo = Get.put(NotificationRepository());

  var notifications = <NotificationModel>[].obs;
  var isLoading = true.obs;
  final _homeRepo = Get.put(HomeRepository());
  var hasUnreadNotifications = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void markAsUnread() {
    hasUnreadNotifications.value = true;
  }

  void markAsRead() {
    hasUnreadNotifications.value = false;
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      final notifList = await _repo.getMyNotifications();

      try {
        final position = await _homeRepo.getCurrentLocation();

        final myAppointments = await _homeRepo.getMyAppointments(
          position.latitude,
          position.longitude,
        );

        final appointmentUrlMap = {
          for (var appt in myAppointments) appt.appointmentId: appt.mapUrl,
        };

        for (var notif in notifList) {
          if (notif.mapUrl == null || notif.mapUrl!.isEmpty) {
            final matchingUrl = appointmentUrlMap[notif.appointmentId];
            if (matchingUrl != null && matchingUrl.isNotEmpty) {
              notif.mapUrl = matchingUrl;
            }
          }
        }
      } catch (e) {
        debugPrint("Could not fetch appointments to enrich notifications: $e");
      }

      notifList.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
      notifications.assignAll(notifList);
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
      CustomLoaders.errorSnackBar(
        title: "Error",
        message: "Failed to load notifications",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> launchMap(String? url) async {
    if (url == null || url.isEmpty) {
      CustomLoaders.warningSnackBar(
        title: "Info",
        message: "No location link provided",
      );
      return;
    }

    final cleanUrl = url.trim();
    final Uri uri = Uri.parse(cleanUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      CustomLoaders.errorSnackBar(
        title: "Error",
        message: "Could not open map: $e",
      );
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
    final date = DateFormat('MMM d, h:mm a').format(model.scheduledAt);

    switch (model.type) {
      case NotificationType.APPOINTMENT_CONFIRMATION:
        return "Success! Your appointment with Ref ID #${model.appointmentId.substring(0, 4)} is confirmed for $date. Tap to view details.";

      case NotificationType.APPOINTMENT_REMINDER:
        return "Reminder: You have an appointment scheduled for $date. Please arrive 10 minutes early. Tap for location.";

      default:
        return "You have a new update regarding your health account. Tap to view more.";
    }
  }

  String formatTime(DateTime time) {
    return DateFormat('MMM d, h:mm a').format(time);
  }
}
