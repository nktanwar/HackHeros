

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/features/home/controllers/search_logic_controller.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchLogicController>();
    
    
    final specialitiesList = ImageStringsConstants.specialities.map((e) => e['name']!).toList();
    
    
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      
      height: screenHeight * 0.6, 
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("All Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => controller.clearAllFilters(),
                child: const Text("Clear All", style: TextStyle(color: Colors.red)),
              )
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
      
          
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const Text("Sort By", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                    spacing: 10,
                    children: [
                      _buildFilterChip(
                        label: "Nearest Doctors",
                        isSelected: controller.selectedSort.value == SortOption.nearest,
                        onSelected: (val) => controller.setSortOption(val ? SortOption.nearest : null),
                      ),
                      _buildFilterChip(
                        label: "Lowest Fees",
                        isSelected: controller.selectedSort.value == SortOption.lowestFees,
                        onSelected: (val) => controller.setSortOption(val ? SortOption.lowestFees : null),
                      ),
                    ],
                  )),
              
                  const SizedBox(height: 20),
              
                  
                  const Text("Speciality", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Obx(() => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: specialitiesList.map((spec) {
                      return _buildFilterChip(
                        label: spec,
                        isSelected: controller.selectedSpeciality.value == spec,
                        onSelected: (val) => controller.setSpeciality(val ? spec : null),
                      );
                    }).toList(),
                  )),
                  
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected, required Function(bool) onSelected}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: ColorConstants.primaryBrandColor.withOpacity(0.2),
      checkmarkColor: ColorConstants.primaryBrandColor,
      labelStyle: TextStyle(
        color: isSelected ? ColorConstants.primaryBrandColor : Colors.black,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}