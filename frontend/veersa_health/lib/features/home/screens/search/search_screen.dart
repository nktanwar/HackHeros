import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/features/home/controllers/search_logic_controller.dart';
import 'package:veersa_health/features/home/screens/home/widgets/doctors_card.dart';
import 'package:veersa_health/features/home/screens/search/widgets/search_bottom_sheet.dart';
import 'package:veersa_health/features/home/screens/search/widgets/search_field_with_filter.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/doctor_detail_screen.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/schedule_appointment_screen.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchLogicController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clearAllFilters();

      final args = Get.arguments;
      if (args != null) {
        if (args['openFilter'] == true) {
          _showFilterSheet(context);
        }
        if (args['speciality'] != null) {
          controller.setSpeciality(args['speciality']);
        }
        if (args['sortBy'] == 'distance') {
          controller.setSortOption(SortOption.nearest);
        }
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
                  if (!controller.showResultsView) {
                    return _buildCategoryGrid(controller);
                  } else {
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
          "Categories",
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
                  child: Image.asset(cat['icon']!),
                ),
                title: Text(
                  cat['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
      return const Center(child: Text("No doctors found"));
    }
    return ListView.separated(
      itemCount: controller.filteredDoctors.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final doc = controller.filteredDoctors[index];
        return DoctorCard(
          doctorName: doc.name,
          doctorSpeciality: doc.speciality,
          imageUrl: doc.image,
          distance: "${doc.distanceKm} km away",
          fees: "Fees: Rs ${doc.fees}",
          onScheduleTap: () {
                Get.to(() => const ScheduleAppointmentScreen());
              },
          onCardTap: () {
                Get.to(() => const DoctorDetailScreen());
              },
        );
      },
    );
  }
}
