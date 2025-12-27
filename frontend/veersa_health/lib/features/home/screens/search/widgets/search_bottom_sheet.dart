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
    final specialitiesList = ImageStringsConstants.specialities
        .map((e) => e['name']!)
        .toList();
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85,
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
              const Text(
                "Filter",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: controller.clearAllFilters,
                child: const Text(
                  "Clear All",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sort By",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Column(
                      children: [
                        _buildRadioTile(
                          title: "Nearest Doctors",
                          value: SortOption.nearest,
                          groupValue: controller.selectedSort.value,
                          onChanged: (val) => controller.setSortOption(val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Distance",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Obx(
                        () => Text(
                          "${controller.searchRadius.value.toInt()} km",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.primaryBrandColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => Slider(
                      value: controller.searchRadius.value,
                      min: 1,
                      max: 100,
                      divisions: 99,
                      activeColor: ColorConstants.primaryBrandColor,
                      onChanged: (val) => controller.updateRadius(val),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Speciality",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: specialitiesList.map((spec) {
                        final isSelected =
                            controller.selectedSpeciality.value == spec;
                        return ChoiceChip(
                          label: Text(spec),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            controller.setSpeciality(selected ? spec : null);
                          },
                          selectedColor: ColorConstants.primaryBrandColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          backgroundColor: Colors.grey.shade100,
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryBrandColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Get.back(),
              child: const Text(
                "Apply Filters",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTile({
    required String title,
    required SortOption value,
    required SortOption? groupValue,
    required Function(SortOption?) onChanged,
  }) {
    return RadioListTile<SortOption>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      activeColor: ColorConstants.primaryBrandColor,
    );
  }
}
