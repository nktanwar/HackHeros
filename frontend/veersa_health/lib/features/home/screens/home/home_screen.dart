import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/common/widgets/header/section_heading_with_button.dart';
import 'package:veersa_health/features/home/controllers/home_controller.dart';
import 'package:veersa_health/features/home/screens/home/widgets/doctor_speciality_list.dart';
import 'package:veersa_health/features/home/screens/home/widgets/home_app_bar.dart';
import 'package:veersa_health/features/home/screens/home/widgets/home_credit_banner.dart';
import 'package:veersa_health/features/home/screens/home/widgets/home_search_bar.dart';
import 'package:veersa_health/features/home/screens/home/widgets/near_by_doctor_list.dart';
import 'package:veersa_health/features/home/screens/home/widgets/upcoming_schedule_list.dart';
import 'package:veersa_health/features/home/screens/search/search_screen.dart';
import 'package:veersa_health/features/my_appointments/screens/appointments/appointment_screen.dart';
import 'package:veersa_health/features/notifications/screens/notification_screen.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Widget (Observer inside)
                HomeAppBar(
                  controller: controller,
                  onNotificationTap: () => Get.to(() => const NotificationScreen()),
                ),

                const SizedBox(height: 24),

                // 2. Search Bar Widget
               HomeSearchBar(
                  onSearchTap: () => Get.to(() => const SearchScreen()), 
                  onFilterTap: () => Get.to(() => const SearchScreen(), arguments: {'openFilter': true}),
                ),

                const SizedBox(height: 24),

                // 3. Upcoming Schedule Section
                SectionHeadingWithButton(
                  sectionHeading: "Upcoming Schedule",
                  isButtonVisible: true,
                  buttonText: "View All",
                  onPressed: () => Get.to(AppointmentScreen()),
                ),
                const SizedBox(height: 16),
                const UpcomingScheduleList(),

                const SizedBox(height: 24),

                // 4. Doctor Speciality Section
                SectionHeadingWithButton(
                  sectionHeading: "Doctor Speciality",
                  isButtonVisible: true,
                  buttonText: "View All",
                  onPressed: () => Get.to(
                    () => const SearchScreen(), 
                  ),
                ),
                const SizedBox(height: 16),
                DoctorSpecialityList(
                   onItemTap: (specialityName) => Get.to(
                     () => const SearchScreen(), 
                     arguments: {'speciality': specialityName} // Case 2 Argument
                   ),
                ),

                const SizedBox(height: 24),

                // 5. Nearby Doctors Section
                SectionHeadingWithButton(
                  sectionHeading: "Nearby Doctors",
                  isButtonVisible: true,
                  buttonText: "View All",
                  onPressed: () => Get.to(
                    () => const SearchScreen(), 
                    arguments: {'sortBy': 'distance'} // Case 3 Argument
                  ),
                ),
                const SizedBox(height: 16),
                const NearbyDoctorsList(),

                const SizedBox(height: 24),

                // 6. Map Banner Widget
                const HomeCreditBanner(),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}