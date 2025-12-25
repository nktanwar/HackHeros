import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  const HomeSearchBar({
    super.key,
    required this.onSearchTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onSearchTap,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: ColorConstants.cardBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorConstants.grey),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.search_normal, color: ColorConstants.primaryBrandColor),
                  const SizedBox(width: 12),
                  const Text(
                    "Search",
                    style: TextStyle(
                        color: ColorConstants.secondaryText, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: ColorConstants.primaryBrandColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Iconsax.setting_4, color: Colors.white),
          ),
        ),
      ],
    );
  }
}