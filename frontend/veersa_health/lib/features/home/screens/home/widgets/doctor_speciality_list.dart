import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class DoctorSpecialityList extends StatelessWidget {
  const DoctorSpecialityList({super.key});
  static String getNameFromAddress(String address) {
    List<String> name = address.split('/');
    debugPrint(name.toString());
    return name[name.length-1].split('.')[0];
  }

  @override
  Widget build(BuildContext context) {
    // 6 Specific specialities
    final List<Map<String, String>> specialities = [
      {'name': getNameFromAddress(ImageStringsConstants.hepatologist), 'icon': ImageStringsConstants.hepatologist},
      {'name': 'Gynecologist', 'icon': ImageStringsConstants.gynecologist},
      {'name': 'Pulmonologist', 'icon': ImageStringsConstants.pulmonologist},
      {
        'name': 'Endocrinologist',
        'icon': ImageStringsConstants.endocrinologist,
      },
      {'name': 'Neurologist', 'icon': ImageStringsConstants.neurologist},
      {'name': 'Cardiologist', 'icon': ImageStringsConstants.cardiologist},
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specialities.length,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: 60,
                width: 60,
                // padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: ColorConstants.backgroundColor,
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Image.asset(
                  specialities[index]['icon']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.medical_services,
                    color: ColorConstants.primaryBrandColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                specialities[index]['name']!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.primaryTextColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
