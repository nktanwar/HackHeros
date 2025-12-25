import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:veersa_health/features/my_appointments/controllers/appointment_controller.dart';

class TimeSlotGrid extends StatelessWidget {
  const TimeSlotGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentController>();

    return Obx(() {
      if (controller.isSlotsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.availableSlots.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12)
          ),
          child: const Center(child: Text("No slots available for this date.")),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.availableSlots.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.5,
        ),
        itemBuilder: (context, index) {
          final slot = controller.availableSlots[index];
          
          // Logic: Format Backend DateTime to "10:00 AM"
          final timeText = DateFormat('hh:mm a').format(slot.startTime.toLocal());
          
          return Obx(() {
            final isSelected = controller.selectedSlot.value == slot;

            return InkWell(
              onTap: () => controller.selectSlot(slot),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF258099) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF258099) : Colors.grey.shade400,
                  ),
                ),
                child: Center(
                  child: Text(
                    timeText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      );
    });
  }
}