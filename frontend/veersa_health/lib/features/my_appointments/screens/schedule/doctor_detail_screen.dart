import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/common/widgets/buttons/custom_elevated_button.dart';
import 'package:veersa_health/features/my_appointments/controllers/doctor_detail_controller.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/widgets/address_card.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/widgets/info_chip.dart';
import 'package:veersa_health/features/my_appointments/screens/schedule/widgets/section_title.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorDetailController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Doctor Profile", style: TextStyle(color: Colors.black)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage("assets/images/map/map_placeholder.png"), 
                          ),
                          const SizedBox(height: 16),
                          Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.doctorName.value,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.verified, color: Colors.blue, size: 20),
                            ],
                          )),
                          const SizedBox(height: 4),
                          Obx(() => Text(
                            controller.speciality.value,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          )),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Obx(() => InfoChip(
                          icon: Iconsax.wallet_2,
                          label: "₹ ${controller.consultationFee.value}",
                          backgroundColor: ColorConstants.primaryBrandColor.withAlpha(26),
                          iconColor: ColorConstants.primaryBrandColor,
                        )),
                        const SizedBox(width: 12),
                        Obx(() => InfoChip(
                          icon: Iconsax.location,
                          label: controller.distance.value,
                        )),
                        const Spacer(),
                        InkWell(
                          onTap: controller.shareProfile,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.share, size: 18, color: Colors.blue),
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

                    const SectionTitle(title: "Experience"),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Iconsax.briefcase, color: ColorConstants.primaryBrandColor),
                          ),
                          const SizedBox(width: 12),
                          Obx(() => Text(
                            controller.experience.value,
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                          )),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const SectionTitle(title: "Bio"),
                    Obx(() => Text(
                      controller.bio.value,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    )),

                    const SizedBox(height: 24),

                    const SectionTitle(title: "Address"),
                    Obx(() => AddressCard(
                      clinicName: controller.clinicName.value,
                      address: controller.address.value,
                    )),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            CustomElevatedButton(onPressed: (){}, child: Text("Schedule Appointment"))
          ],
        ),
      ),
    );
  }
}