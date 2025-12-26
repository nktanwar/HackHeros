import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.nearbyDoctors.isEmpty) {
        return const Center(child: Text("No doctors found nearby"));
      }

      return SizedBox(
        height: 180, // Slightly increased height for better layout
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
                doctorName: doctor.clinicName, // Using Clinic Name as per API
                doctorSpeciality: doctor.specialty,
                imageUrl: doctor.image,
                distance: "${doctor.distanceInKm.toStringAsFixed(1)} km",
                fees: "Fees: Rs ${doctor.fees.toInt()}",
                onScheduleTap: () {
                  // Pass doctorId to booking screen
                  Get.to(() => const ScheduleAppointmentScreen(), arguments: {
                    'doctorId': doctor.doctorId,
                    'clinicName': doctor.clinicName
                  });
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