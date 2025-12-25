// lib/features/home/screens/search/widgets/search_field_with_filter.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/features/home/controllers/search_logic_controller.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class SearchFieldWithFilter extends StatelessWidget {
  final VoidCallback onFilterTap;

  const SearchFieldWithFilter({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchLogicController>();

    return Row(
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: ColorConstants.grey
          ),
          onPressed: () => Get.back(),
          icon: Icon(Iconsax.arrow_left,weight:600, color: Colors.black),
        ),
        const SizedBox(width: 12,),
        // Search Input
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorConstants.grey),
            ),
            child: TextField(
              onChanged: (val) => controller.updateSearchQuery(val),
              decoration: const InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: ColorConstants.secondaryText),
                prefixIcon: Icon(Iconsax.search_normal, color: ColorConstants.primaryBrandColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Filter Button with Badge
        GestureDetector(
          onTap: onFilterTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: ColorConstants.primaryBrandColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Iconsax.setting_4, color: Colors.white),
              ),
              // Filter Badge (Observer)
              Obx(() {
                if (controller.activeFilterCount == 0) return const SizedBox();
                return Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${controller.activeFilterCount}",
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}