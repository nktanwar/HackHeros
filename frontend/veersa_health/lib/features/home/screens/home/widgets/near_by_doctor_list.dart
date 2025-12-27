import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/common/loaders/shimmer_effect.dart';
import 'package:veersa_health/features/home/controllers/home_controller.dart';
import 'package:veersa_health/features/home/screens/home/widgets/doctors_card.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/doctor_detail_screen.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/schedule_appointment_screen.dart';

class NearbyDoctorsList extends StatelessWidget {
  const NearbyDoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      if (controller.isDataLoading.value) {
        return SizedBox(
          height: 190,
          child: ListView.separated(
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(width: 12,),
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, _) => CustomShimmerEffect(width: 300, height: 190),
          ),
        );

      }

      if (controller.nearbyDoctors.isEmpty) {
        return Container(
          color: Colors.white,
          child: const Center(child: Text("No doctors found nearby")),
        );
      }

      return SizedBox(
        height: 190,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(bottom: 10),
          itemCount: controller.nearbyDoctors.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final doctor = controller.nearbyDoctors[index];

            return SizedBox(
              width: 300,
              child: DoctorCard(
                clinicName: doctor.clinicName,
                doctorSpeciality: doctor.specialty,
                imageUrl: doctor.image,
                distance: "${doctor.distanceInKm.toStringAsFixed(1)} km",
                onScheduleTap: () {
                  Get.to(
                    () => const ScheduleAppointmentScreen(),
                    arguments: {
                      'doctorId': doctor.doctorId,
                      'clinicName': doctor.clinicName,
                    },
                  );
                },
                onCardTap: () {
                  Get.to(() => const DoctorDetailScreen(), arguments: doctor);
                },
              ),
            );
          },
        ),
      );
    });
  }
}
