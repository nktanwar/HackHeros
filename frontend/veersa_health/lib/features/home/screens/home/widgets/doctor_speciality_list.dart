import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class DoctorSpecialityList extends StatelessWidget {
  // 1. Add a callback function to handle taps
  final void Function(String specialityName)? onItemTap;

  const DoctorSpecialityList({
    super.key, 
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure we don't exceed the list length if the constant has fewer than 5 items
    final fullList = ImageStringsConstants.specialities;
    final int count = fullList.length < 5 ? fullList.length : 5;
    final List<Map<String, String>> specialities = fullList.sublist(0, count);

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        // 2. Use the actual length of the sublist to prevent RangeErrors
        itemCount: specialities.length,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final String name = specialities[index]['name']!;
          final String icon = specialities[index]['icon']!;

          // 3. Wrap in GestureDetector to detect clicks
          return GestureDetector(
            onTap: () {
              // Trigger the callback if it exists, passing the speciality name
              if (onItemTap != null) {
                onItemTap!(name);
              }
            },
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    color: ColorConstants.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                  child: Image.asset(
                    icon,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.medical_services,
                      color: ColorConstants.primaryBrandColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.primaryTextColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}