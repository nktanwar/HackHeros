import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/common/widgets/buttons/custom_elevated_button.dart';
import 'package:veersa_health/features/my_appointments/controllers/doctor_detail_controller.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/widgets/address_card.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/widgets/info_chip.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/widgets/section_title.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorDetailController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Doctor Profile",
          style: TextStyle(color: Colors.black, fontFamily: "Montserrat"),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Obx(() {
                  if (controller.doctorData.value == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: AssetImage(
                                ImageStringsConstants.avatar3,
                              ),
                              onBackgroundImageError: (_, __) {},
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.doctorName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.specialty,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          InfoChip(
                            icon: Iconsax.location,
                            label: controller.distance,
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: controller.shareProfile,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Share",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const SectionTitle(title: "Address"),
                      AddressCard(
                        clinicName:
                            controller.doctorData.value?.clinicName ?? "Clinic",
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                }),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomElevatedButton(
                onPressed: controller.navigateToBooking,
                child: const Text("Schedule Appointment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
