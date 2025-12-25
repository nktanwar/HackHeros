import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/features/home/controllers/home_controller.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class HomeAppBar extends StatelessWidget {
  final HomeController controller;
  final VoidCallback onNotificationTap;

  const HomeAppBar({
    super.key,
    required this.controller,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorConstants.secondaryText,
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: controller.refreshLocation,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Iconsax.location,
                      color: ColorConstants.primaryBrandColor,
                      size: 25,
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
                          controller.currentLocation.value,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: ColorConstants.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }),
                    const SizedBox(width: 4),
                    
                    Obx(() => controller.isFetchingLocation.value
                        ? const SizedBox.shrink()
                        : const Icon(Icons.keyboard_arrow_down,
                            color: ColorConstants.darkGrey)),
                  ],
                ),
              ),
            ],
          ),
        ),
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
            icon: const Icon(Iconsax.notification_bing,
                color: Colors.black),
          ),
        ),
      ],
    );
  }
}