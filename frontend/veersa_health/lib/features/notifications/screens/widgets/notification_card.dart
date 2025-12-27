import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String dateTime;
  final bool isReminder;
  final VoidCallback? onMapTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.dateTime,
    this.isReminder = false,
    this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMapTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isReminder
                        ? Colors.orange.withOpacity(0.1)
                        : ColorConstants.primaryBrandColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isReminder ? Iconsax.clock : Iconsax.tick_circle,
                    color: isReminder
                        ? Colors.orange
                        : ColorConstants.primaryBrandColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.primaryTextColor,
                              ),
                            ),
                          ),
                          Text(
                            dateTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (onMapTap != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onMapTap,
                  icon: const Icon(Iconsax.map, size: 18),
                  label: const Text("Get Directions"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorConstants.white,
                    side: const BorderSide(
                      color: ColorConstants.primaryBrandColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
