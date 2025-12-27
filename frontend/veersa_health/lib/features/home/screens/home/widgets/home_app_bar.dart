import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/features/home/controllers/home_controller.dart';
import 'package:veersa_health/features/notifications/controllers/notification_controller.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class HomeAppBar extends StatelessWidget {
  final HomeController controller;
  final VoidCallback onNotificationTap;
  final VoidCallback onProfileTap;

  const HomeAppBar({
    super.key,
    required this.controller,
    required this.onNotificationTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final notifController = Get.put(NotificationController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Location",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: ColorConstants.darkGrey),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: controller.initializeData,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Iconsax.location,
                        color: ColorConstants.primaryBrandColor,
                        size: 20,
                      ),
                      const SizedBox(width: 6),

                      Obx(() {
                        if (controller.isFetchingLocation.value) {
                          return const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        return Flexible(
                          child: Text(
                            controller.address.value.isEmpty
                                ? "Select Location"
                                : controller.address.value,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: ColorConstants.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }),

                      const SizedBox(width: 4),

                      Obx(
                        () => controller.isFetchingLocation.value
                            ? const SizedBox.shrink()
                            : const Icon(
                                Icons.keyboard_arrow_down,
                                color: ColorConstants.darkGrey,
                                size: 18,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorConstants.grey,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: onNotificationTap,
                icon: const Icon(
                  Iconsax.notification_bing,
                  color: Colors.black,
                ),
              ),
            ),

            Obx(() {
              return notifController.hasUnreadNotifications.value
                  ? Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          ],
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: ColorConstants.primaryBrandColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onProfileTap,
            icon: const Icon(Iconsax.user, color: ColorConstants.white),
          ),
        ),
      ],
    );
  }
}
