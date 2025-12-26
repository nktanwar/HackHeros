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
    // Inject the Hybrid Controller
    final controller = Get.put(SearchLogicController());

    // Handle arguments passed from Home Screen (e.g., View All Specialities)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Reset filters when entering fresh
      // Note: If you want to keep state when going back/forth, remove clearAllFilters()
      // controller.clearAllFilters(); 

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
              // 1. Search Bar
              SearchFieldWithFilter(
                onFilterTap: () => _showFilterSheet(context),
              ),
              const SizedBox(height: 24),

              // 2. Results Area
              Expanded(
                child: Obx(() {
                  // A. Show Loading Spinner
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // B. Show Categories if no search is active
                  if (!controller.showResultsView) {
                    return _buildCategoryGrid(controller);
                  } 
                  
                  // C. Show Filtered Results
                  else {
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

  // --- Widget: Category Grid (Unchanged) ---
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

  // --- Widget: Search Results List (UPDATED) ---
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
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: controller.filteredDoctors.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        // Get the specific doctor model
        final doc = controller.filteredDoctors[index];
        
        return DoctorCard(
          // Mapped 'clinicName' to 'doctorName' parameter if your card expects that
          // Or update DoctorCard to accept 'clinicName'
          doctorName: doc.clinicName, 
          doctorSpeciality: doc.specialty,
          imageUrl: doc.image, // Uses default placeholder from model
          
          // Formatted Distance
          distance: "${doc.distanceInKm.toStringAsFixed(1)} km away",
          
          // Formatted Fees
          fees: "Fees: Rs ${doc.fees.toInt()}",
          
          onScheduleTap: () {
            Get.to(
              () => const ScheduleAppointmentScreen(),
              arguments: {
                'doctorId': doc.doctorId,
                'clinicName': doc.clinicName,
              }
            );
          },
          onCardTap: () {
            Get.to(
              () => const DoctorDetailScreen(),
              arguments: doc // Pass the full model object
            );
          },
        );
      },
    );
  }
}