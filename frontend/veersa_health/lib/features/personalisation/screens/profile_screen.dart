import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/features/my_appointments/screens/appointments/appointment_screen.dart';
import 'package:veersa_health/features/notifications/screens/notification_screen.dart';
import 'package:veersa_health/features/personalisation/controllers/profile_controller.dart';
import 'package:veersa_health/features/personalisation/screens/widget/profile_menu_tile.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Controller
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Hide back button on main tab
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.fetchUserProfile, // Add Pull-to-refresh
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(SizeConstants.defaultSpace),
            child: Column(
              children: [
                // --- 1. Profile Header (Reactive) ---
                SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      children: [
                        // Avatar
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorConstants.primaryBrandColor,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(controller.profileImage.value),
                            backgroundColor: Colors.grey.shade200,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Name from API
                        Text(
                          controller.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),

                        // Email from API
                        Text(
                          controller.email,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),

                        // Phone from API
                        if (controller.phone.isNotEmpty)
                          Text(
                            controller.phone,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                // --- 2. Menu Options ---
                ProfileMenuTile(
                  icon: Iconsax.notification,
                  title: 'Notifications',
                  onPress: () => Get.to(() => const NotificationScreen()),
                ),
                const SizedBox(height: 10),
                ProfileMenuTile(
                  icon: Iconsax.calendar_tick,
                  title: 'My Appointments',
                  onPress: () => Get.to(() => AppointmentScreen()),
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 20),

                // --- 3. Logout Button ---
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => controller.logout(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}