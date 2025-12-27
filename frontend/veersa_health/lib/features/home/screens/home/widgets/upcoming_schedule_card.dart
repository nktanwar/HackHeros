import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class UpcomingScheduleCard extends StatelessWidget {
  final String doctorName;
  final String doctorSpeciality;
  final String dateOfAppointment;
  final String timeOfAppointment;
  final String doctorProfileImage;
  final VoidCallback onMapTap;
  final VoidCallback onCardTap;

  const UpcomingScheduleCard({
    super.key,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.dateOfAppointment,
    required this.timeOfAppointment,
    required this.doctorProfileImage,
    required this.onMapTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color tealBackground = Color(0xFF22677A);

    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: tealBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(doctorProfileImage),
                      onBackgroundImageError: (_, __) =>
                          const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctorSpeciality,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  InkWell(
                    onTap: onMapTap,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Iconsax.location,
                        color: tealBackground,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                color: ColorConstants.primaryBrandColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.calendar_1, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    dateOfAppointment,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const Spacer(),

                  const Icon(Iconsax.clock, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    timeOfAppointment,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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
}
