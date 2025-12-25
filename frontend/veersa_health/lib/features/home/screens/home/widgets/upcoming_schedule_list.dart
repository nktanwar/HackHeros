import 'package:flutter/material.dart';
import 'package:veersa_health/features/home/screens/home/widgets/upcoming_schedule_card.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class UpcomingScheduleList extends StatelessWidget {
  const UpcomingScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 2, 
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return const UpcomingScheduleCard(
            doctorName: "Dr. Kanti Kushwaha",
            doctorSpeciality: "Dentist Consultation",
            dateOfAppointment: "Saturday, 27 Dec, 25",
            timeOfAppointment: "11:59 PM",
            doctorProfileImage: ImageStringsConstants.avatar2,
            clinicLocation: "Huda Panipat",
          );
        },
      ),
    );
  }
}