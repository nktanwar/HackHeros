import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:veersa_health/common/loaders/shimmer_effect.dart';
import 'package:veersa_health/features/home/controllers/home_controller.dart';
import 'package:veersa_health/features/home/screens/home/widgets/upcoming_schedule_card.dart';
import 'package:veersa_health/features/my_appointments/screens/appointments/appointment_detail_screen.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class UpcomingScheduleList extends StatelessWidget {
  const UpcomingScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isFetchingLocation.value ||
          controller.isDataLoading.value) {
        return const CustomShimmerEffect(width: double.infinity, height: 160);
      }

      if (controller.upcomingAppointments.isEmpty) {
        return Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorConstants.primaryBrandColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              "No upcoming appointments",
              style: TextStyle(color: ColorConstants.backgroundColor,fontSize: 16,fontWeight: FontWeight.w600),
            ),
          ),
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

            final dateStr = DateFormat(
              'EEEE, d MMM, yy',
            ).format(appt.startTime);

            final timeStr = DateFormat('jm').format(appt.startTime);

            return UpcomingScheduleCard(
              doctorName: appt.doctorName,
              doctorSpeciality: appt.specialty,
              dateOfAppointment: dateStr,
              timeOfAppointment: timeStr,
              doctorProfileImage: appt.doctorImage,

              onMapTap: () {
                controller.launchMapUrl(appt.mapUrl);
              },

              onCardTap: () {
                Get.to(() => const AppointmentDetailScreen(), arguments: appt);
              },
            );
          },
        ),
      );
    });
  }
}
