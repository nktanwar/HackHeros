import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/common/loaders/shimmer_effect.dart';
import 'package:veersa_health/features/home/controllers/search_logic_controller.dart';
import 'package:veersa_health/features/home/screens/home/widgets/doctors_card.dart';
import 'package:veersa_health/features/home/screens/search/widgets/search_bottom_sheet.dart';
import 'package:veersa_health/features/home/screens/search/widgets/search_field_with_filter.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/doctor_detail_screen.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchLogicController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args != null && args['openFilter'] == true) {
        _showFilterSheet(context);
      }
    });

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              SearchFieldWithFilter(
                onFilterTap: () => _showFilterSheet(context),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return SizedBox(
                      width: double.infinity,
                      child: ListView.separated(
                        itemCount: 6,
                        scrollDirection: Axis.vertical,
                        separatorBuilder: (context, index) => const SizedBox(height: 12,),
                        itemBuilder: (context, index) {
                          return CustomShimmerEffect(
                            width: double.infinity,
                            height: 190,
                          );
                        },
                      ),
                    );
                  }

                  if (!controller.showResultsView) {
                    return _buildCategoryGrid(controller);
                  } else {
                    if (controller.isFiltering.value) {
                      return Center(child: SizedBox(
                      width: double.infinity,
                      child: ListView.separated(
                        itemCount: 6,
                        scrollDirection: Axis.vertical,
                        separatorBuilder: (context, index) => const SizedBox(height: 12,),
                        itemBuilder: (context, index) {
                          return const CustomShimmerEffect(
                            width: double.infinity,
                            height: 190,
                          );
                        },
                      ),
                    )
                    );
                    }
                    return _buildSearchResultsList(controller);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  Widget _buildCategoryGrid(SearchLogicController controller) {
    final categories = ImageStringsConstants.specialities;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Doctor's Specialty",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return ListTile(
                onTap: () => controller.setSpeciality(cat['name']),
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      cat['icon']!,
                      fit: BoxFit.cover,
                      // This prevents the "Unable to load asset" crash
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.local_hospital,
                          color: ColorConstants.primaryBrandColor,
                        );
                      },
                    ),
                  ),
                ),
                title: Text(
                  cat['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultsList(SearchLogicController controller) {
    if (controller.filteredDoctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              "No doctors found.",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: controller.clearAllFilters,
              child: const Text("Clear Filters"),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: controller.filteredDoctors.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final doc = controller.filteredDoctors[index];

        return DoctorCard(
          clinicName: doc.clinicName,
          doctorSpeciality: doc.specialty,
          imageUrl: doc.image,
          distance: "${doc.distanceInKm.toStringAsFixed(1)} km away",
          onScheduleTap: () {
            Get.to(() => const DoctorDetailScreen(), arguments: doc);
          },
        );
      },
    );
  }
}
