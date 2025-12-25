import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';

class AppointmentDetailScreen extends StatelessWidget {
  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Retrieve the data passed from the previous screen
    final AppointmentModel appointment = Get.arguments;

    // 2. Logic to determine status UI
    final bool isUpcoming = appointment.status == AppointmentStatus.BOOKED;
    final Color statusColor = isUpcoming ? const Color(0xFF5E9EA0) : Colors.grey;
    final String statusText = isUpcoming ? "Upcoming Appointment" : appointment.status.name;

    // 3. Date Formatting
    final String formattedDate = DateFormat('EEEE, MMMM d, y').format(appointment.startTime);
    final String formattedTime = DateFormat('h:mm a').format(appointment.startTime);

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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
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
                    // Use 'doctorImage' from the updated model
                    backgroundImage: NetworkImage(appointment.doctorImage),
                    backgroundColor: Colors.grey.shade200,
                    onBackgroundImageError: (_,_) {}, // Handle error silently
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
                              "+91 9876543210", // Placeholder (Backend didn't provide phone)
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
                            formattedDate, // Used formatted date
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedTime, // Used formatted time
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
                                height: 1.4,
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
                      child: Image.network(
                        "https://maps.googleapis.com/maps/api/staticmap?center=Panipat,Haryana&zoom=14&size=600x300&key=YOUR_API_KEY", // Real logic would go here
                        fit: BoxFit.cover,
                        errorBuilder: (c, o, s) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                              child: Icon(Icons.map, color: Colors.grey, size: 40)),
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
                        backgroundColor: const Color(0xFF5391B4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.location_on_outlined, color: Colors.white),
                      label: const Text(
                        "Get Directions",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
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
                "Booked on ${DateFormat('MMM d, h:mm a').format(DateTime.now())}", // Ideally appointment.createdAt from backend
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}