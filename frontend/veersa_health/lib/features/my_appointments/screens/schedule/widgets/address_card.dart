import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class AddressCard extends StatelessWidget {
  final String clinicName;

  const AddressCard({
    super.key,
    required this.clinicName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.location, size: 18, color: ColorConstants.primaryBrandColor),
                    const SizedBox(width: 6),
                    Text(
                      clinicName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ColorConstants.primaryBrandColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "COMPLETED",
                style: TextStyle(
                  color: ColorConstants.primaryBrandColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        // Map Placeholder (Image)
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            image: const DecorationImage(
              image: NetworkImage("assets/images/map/map_placeholder.png"), // Placeholder map image
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Icon(Icons.location_on, color: Colors.red.shade700, size: 40),
          ),
        ),
      ],
    );
  }
}