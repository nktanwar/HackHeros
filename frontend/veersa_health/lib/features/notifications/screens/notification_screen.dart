import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/features/notifications/controllers/notification_controller.dart';
import 'package:veersa_health/features/notifications/screens/widgets/notification_card.dart';
import 'package:veersa_health/features/notifications/screens/notification_detail_screen.dart'; 
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
              fontSize: 18),
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildTabButton(
                        text: "Unread",
                        count: controller.unreadList.length,
                        isActive: true,
                      ),
                      const SizedBox(width: 10),
                      _buildTabButton(
                        text: "Read",
                        count: controller.readList.length,
                        isActive: false,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: controller.markAllAsRead,
                    child: const Text(
                      "Mark All as Read",
                      style: TextStyle(
                          color: ColorConstants.primaryBrandColor, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),

            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    
                    if (controller.unreadList.isNotEmpty) ...[
                      ...controller.unreadList.map((model) => GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  NotificationDetailScreen(notification: model));
                            },
                            child: NotificationCard(
                              isUnread: true,
                              title: model.title,
                              description: model.description,
                              timeAgo: model.timeAgo,
                              dateTime: model.dateTime,
                            ),
                          )),
                    ],

                    const SizedBox(height: 10),

                    
                    if (controller.readList.isNotEmpty) ...[
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Read",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3545),
                            ),
                          ),
                          TextButton(
                            onPressed: controller.clearAllRead,
                            child: const Text(
                              "Clear All",
                              style: TextStyle(
                                  color: ColorConstants.primaryBrandColor),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),

                      
                      ...controller.readList.map((model) => GestureDetector(
                            onTap: () {
                              Get.to(() =>
                                  NotificationDetailScreen(notification: model));
                            },
                            child: NotificationCard(
                              isUnread: false,
                              title: model.title,
                              description: model.description,
                              timeAgo: model.timeAgo,
                              dateTime: model.dateTime,
                              iconData: model.iconData,
                            ),
                          )),
                    ]
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  
  Widget _buildTabButton(
      {required String text, required int count, required bool isActive}) {
    const activeColor = Color(0xFF558BAA);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? activeColor : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isActive ? Colors.white.withAlpha(54) : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}