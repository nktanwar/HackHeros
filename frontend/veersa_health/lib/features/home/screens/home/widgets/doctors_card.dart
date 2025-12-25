import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final String doctorSpeciality;
  final String imageUrl;
  final String distance;
  final String fees;
  final VoidCallback onScheduleTap;

  const DoctorCard({
    super.key,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.imageUrl,
    required this.distance,
    required this.fees,
    required this.onScheduleTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.grey.withAlpha(77),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor's Profile Image
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: 8),
              // Doctor's Info & Distance Tag
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      doctorSpeciality,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Distance Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 3.0,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstants.primaryBrandColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Iconsax.location,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            distance,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Fees Tag
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  fees,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Schedule Appointment Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onScheduleTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryBrandColor,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Schedule Appointment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}