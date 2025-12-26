import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/features/notifications/controllers/notification_controller.dart';
import 'package:veersa_health/features/notifications/models/notificaton_model.dart';
import 'package:veersa_health/features/notifications/screens/widgets/notification_card.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: ColorConstants.primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  "No notifications yet",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              
              return NotificationCard(
                title: controller.getTitle(notification),
                description: controller.getDescription(notification),
                dateTime: controller.formatTime(notification.scheduledAt),
                isReminder: notification.type == NotificationType.APPOINTMENT_REMINDER,
                onMapTap: (notification.mapUrl != null && notification.mapUrl!.isNotEmpty)
                    ? () => controller.launchMap(notification.mapUrl)
                    : null,
              );
            },
          ),
        );
      }),
    );
  }
}