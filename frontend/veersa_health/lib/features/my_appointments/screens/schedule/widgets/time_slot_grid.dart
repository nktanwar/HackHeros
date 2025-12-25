import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/features/my_appointments/controllers/appointment_controller.dart';

class TimeSlotGrid extends StatelessWidget {
  const TimeSlotGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppointmentController>();

    
    return Obx(() => GridView.builder(
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
        final timeText = slot['time'] as String;
        final isAvailable = slot['isAvailable'] as bool;
        
        return Obx(() {
          final isSelected = controller.selectedTimeSlot.value == timeText;

          return InkWell(
            onTap: isAvailable 
                ? () => controller.selectTimeSlot(timeText) 
                : null,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                
                color: !isAvailable
                    ? Colors.grey.shade200 
                    : isSelected
                        ? const Color(0xFF258099) 
                        : Colors.white, 
                
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: !isAvailable
                      ? Colors.transparent
                      : isSelected
                          ? const Color(0xFF258099)
                          : Colors.grey.shade400,
                ),
              ),
              child: Center(
                child: Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: !isAvailable
                        ? Colors.grey.shade500 
                        : isSelected
                            ? Colors.white 
                            : Colors.black, 
                  ),
                ),
              ),
            ),
          );
        });
      },
    ));
  }
}