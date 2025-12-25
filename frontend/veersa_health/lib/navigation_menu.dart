import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/features/home/screens/home/home_screen.dart';
import 'package:veersa_health/features/my_appointments/screens/appointment_screen.dart';
import 'package:veersa_health/features/notifications/screens/notification_screen.dart';
import 'package:veersa_health/features/personalisation/screens/profile_screen.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationBarController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected:
              (index) => {controller.selectedIndex.value = index},
          indicatorColor:ColorConstants.primaryBrandColor,
              
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(icon: Icon(Iconsax.calendar_tick), label: "My Appointments"),
            NavigationDestination(
              icon: Icon(Iconsax.notification_bing),
              label: "Notification",
            ),
            NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationBarController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    AppointmentScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];
}
