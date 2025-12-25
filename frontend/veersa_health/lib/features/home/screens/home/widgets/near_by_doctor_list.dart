import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:veersa_health/features/home/screens/home/widgets/doctors_card.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/doctor_detail_screen.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/schedule_appointment_screen.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class NearbyDoctorsList extends StatelessWidget {
  const NearbyDoctorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 10),
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 300,
            child: DoctorCard(
              doctorName: "Dr. Priya Garg",
              doctorSpeciality: "Dentist",
              imageUrl: ImageStringsConstants.avatar4,
              distance: "20 km away",
              fees: "Fees: Rs 80",
              onScheduleTap: () {
                Get.to(() => const ScheduleAppointmentScreen());
              },
              onCardTap: () {
                Get.to(() => const DoctorDetailScreen());
              },
            ),
          );
        },
      ),
    );
  }
}