import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import intl
import 'package:veersa_health/features/home/controllers/home_controller.dart';
import 'package:veersa_health/features/home/screens/home/widgets/upcoming_schedule_card.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class UpcomingScheduleList extends StatelessWidget {
  const UpcomingScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isDataLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.upcomingAppointments.isEmpty) {
        return Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Text("No upcoming appointments")),
        );
      }

      return SizedBox(
        height: 145,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.upcomingAppointments.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final appt = controller.upcomingAppointments[index];
            
            // Format Date: "Sat, 27 Dec"
            final dateStr = DateFormat('EEE, d MMM').format(appt.startTime);
            // Format Time: "10:30 AM"
            final timeStr = DateFormat('jm').format(appt.startTime);

            return UpcomingScheduleCard(
              doctorName: "Dr. ID: ${appt.doctorId}", // Backend doesn't give name in Appt API
              doctorSpeciality: "Consultation",
              dateOfAppointment: dateStr,
              timeOfAppointment: timeStr,
              doctorProfileImage: ImageStringsConstants.avatar2,
              clinicLocation: "Veersa Clinic", // Placeholder
            );
          },
        ),
      );
    });
  }
}