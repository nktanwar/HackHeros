import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class HomeCreditBanner extends StatelessWidget {
  const HomeCreditBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(ImageStringsConstants.appIcon, width: 30, height: 30),

          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Veersa Health',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Made With ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  Icon(Iconsax.heart, size: 10,color: Colors.red),
                ],
              ),
              Text(
                "by Sachin, Pankaj & Shashikant",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
