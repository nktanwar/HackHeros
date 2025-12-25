import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String timeAgo;
  final String dateTime;
  final bool isUnread;
  final IconData? iconData;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.dateTime,
    this.isUnread = false,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    
    const Color textGrey = Color(0xFF6B7280);
    const Color borderGrey = Color(0xFFE5E7EB);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        
        color:  ColorConstants.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: isUnread
            ? Border.all(color: Colors.transparent)
            : Border.all(color: borderGrey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.only(top: 4.0), 
            child: isUnread
                ? Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: ColorConstants.primaryBrandColor,
                      shape: BoxShape.circle,
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EFF5), 
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      iconData ?? Icons.notifications_outlined,
                      color: const Color(0xFF405F75),
                      size: 20,
                    ),
                  ),
          ),
          
          const SizedBox(width: 12),

          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        timeAgo,
                        style: const TextStyle(
                          color: textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                
                
                Text(
                  description,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 14,
                    height: 1.4, 
                  ),
                ),
                
                const SizedBox(height: 8),
                
                
                Text(
                  dateTime,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}