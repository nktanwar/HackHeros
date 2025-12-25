import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';
// Ensure you import your Appointment model and Controller if in a separate file

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Retrieve the data passed from the previous screen
    // We assume an 'Appointment' object was passed via Get.to()
    final Appointment appointment = Get.arguments;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Light grey-blue background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text("Appointment Details"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
            color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOP ROW: STATUS & RESCHEDULE ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E9EA0), // Teal color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Upcoming Appointment",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Integration Point: Call controller.reschedule(appointment.id)
                    Get.snackbar("Action", "Reschedule functionality goes here");
                  },
                  child: const Text(
                    "Reschedule",
                    style: TextStyle(
                      color: Colors.blueGrey, 
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            // --- DOCTOR CARD ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(appointment.doctorImageUrl),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctorName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment.specialty,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.call, size: 16, color: Color(0xFF5E9EA0)),
                            const SizedBox(width: 6),
                            Text(
                              appointment.phoneNumber,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- "APPOINTMENT INFO" TITLE ---
            const Text(
              "Appointment Info",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),

            const SizedBox(height: 12),

            // --- MAIN INFO CONTAINER ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  // Date Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.calendar_today, 
                            size: 20, color: Colors.blueGrey.shade700),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // Logic to format date nicely
                             "Thursday, April ${appointment.appointmentDate.day}, ${appointment.appointmentDate.year}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${appointment.appointmentDate.hour > 12 ? appointment.appointmentDate.hour - 12 : appointment.appointmentDate.hour}:${appointment.appointmentDate.minute.toString().padLeft(2, '0')} ${appointment.appointmentDate.hour >= 12 ? 'PM' : 'AM'}",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Location Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.location_on, 
                            size: 20, color: Colors.blueGrey.shade700),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.clinicName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF2D3142),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              appointment.address,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                                height: 1.4
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Map Image (Placeholder)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 120,
                      width: double.infinity,
                      // Using a network image to simulate the map in your screenshot
                      child: Image.network(
                        "https://i.imgur.com/K3yZ0G5.png", // Generic map placeholder
                        fit: BoxFit.cover,
                        errorBuilder: (c,o,s) => Container(
                          color: Colors.grey.shade200, 
                          child: const Center(child: Icon(Icons.map, color: Colors.grey))
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Get Directions Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Integration: Launch Google Maps
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5391B4), // Muted Blue from image
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.location_on_outlined, color: Colors.white),
                      label: const Text(
                        "Get Directions",
                        style: TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            
            // Footer Timestamp
            Center(
              child: Text(
                "Today, 2:30 PM",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}