import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/features/my_appointments/controllers/appointment_controller.dart';
import 'package:veersa_health/features/my_appointments/screens/appointments/appointment_detail_screen.dart';
import 'package:veersa_health/features/my_appointments/screens/appointments/widgets/appointment_card.dart';

class AppointmentScreen extends StatelessWidget {
  final AppointmentController controller = Get.put(AppointmentController());

  AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text("My Appointments"),
      ),
      body: Column(
        children: [
          // --- CUSTOM TAB TOGGLE ---
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Obx(() => Row(
              children: [
                _buildTabButton("Upcoming", 0),
                _buildTabButton("Previous", 1),
              ],
            )),
          ),

          // --- APPOINTMENT LIST ---
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Decide which list to show
              final appointments = controller.selectedTab.value == 0
                  ? controller.upcomingAppointments
                  : controller.previousAppointments;

              if (appointments.isEmpty) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, size: 50, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text(
                        controller.selectedTab.value == 0 
                          ? "No upcoming appointments" 
                          : "No history found",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppointmentCard(
                        appointment: appointment,
                        onTap: () => Get.to(() => const AppointmentDetailScreen(), arguments: appointment),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper widget for the custom tab button
  Widget _buildTabButton(String text, int index) {
    final isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.switchTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF5E9EA0) : Colors.transparent, // Teal-ish blue
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

