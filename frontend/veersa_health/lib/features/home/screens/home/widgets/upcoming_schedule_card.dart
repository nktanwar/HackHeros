import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class UpcomingScheduleCard extends StatelessWidget {
  final String doctorName;
  final String doctorSpeciality;
  final String dateOfAppointment;
  final String timeOfAppointment;
  final String doctorProfileImage;
  final String clinicLocation;

  const UpcomingScheduleCard({
    super.key,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.dateOfAppointment,
    required this.timeOfAppointment,
    required this.doctorProfileImage,
    required this.clinicLocation,
  });

  Future<void> _launchMaps() async {
    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(clinicLocation)}",
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch maps");
    }
  }

  @override
  Widget build(BuildContext context) {

    const Color darkTeal = Color(0xFF22677A);

    return Container(
      width: 358,
      height: 145,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorConstants.primaryBrandColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(doctorProfileImage),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      doctorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctorSpeciality,
                      style: TextStyle(
                        color: Colors.white.withAlpha(220),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              InkWell(
                onTap: _launchMaps,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.location,
                    color: ColorConstants.primaryBrandColor,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          Container(
            height: 50,
            decoration: BoxDecoration(
              color: darkTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Iconsax.calendar,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateOfAppointment,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 1,
                  height: 25,
                  color: Colors.white.withAlpha(76),
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Iconsax.clock,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeOfAppointment,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
