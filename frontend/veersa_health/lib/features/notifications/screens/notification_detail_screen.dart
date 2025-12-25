import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/features/notifications/controllers/notification_controller.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF558BAA);
    const Color textDark = Color(0xFF2C3545);
    const Color textGrey = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          "Notification",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                _buildTabButton(text: "Unread", count: 2, isActive: true),
                const SizedBox(width: 10),
                _buildTabButton(text: "Read", count: 8, isActive: false),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(13),
                    spreadRadius: 2,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryBlue.withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        // CHANGED: Use dynamic icon from model, fallback to notification icon
                        child: Icon(
                          notification.iconData ?? Icons.notifications, 
                          color: primaryBlue, 
                          size: 20
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded( // Added Expanded to prevent overflow on long titles
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    notification.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: textGrey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (notification.doctorName != null || notification.clinicName != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(13),
                      spreadRadius: 2,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (notification.doctorName != null) ...[
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(ImageStringsConstants.avatar5),
                            backgroundColor: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.doctorName!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                              if (notification.doctorSpecialty != null)
                                Text(
                                  notification.doctorSpecialty!,
                                  style: const TextStyle(color: textGrey, fontSize: 13),
                                ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                    ],

                    if (notification.clinicName != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: textGrey, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            notification.clinicName!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                      if (notification.address != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0, top: 4),
                          child: Text(
                            notification.address!,
                            style: const TextStyle(color: textGrey, fontSize: 13),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],

                    if (notification.showMap)
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage('https://static.vecteezy.com/system/resources/previews/000/553/960/non_2x/vector-isometric-map-city-infographic-elements.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.location_on, color: Colors.red.shade700, size: 40),
                        ),
                      ),
                    
                    const SizedBox(height: 20),

                    if (notification.showMap || notification.address != null)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                          },
                          icon: const Icon(Icons.location_on_outlined, color: Colors.white),
                          label: const Text("Get Directions", style: TextStyle(color: Colors.white, fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    Center(
                      child: Text(
                        notification.dateTime,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({required String text, required int count, required bool isActive}) {
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