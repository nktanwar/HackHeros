import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment; 
  final VoidCallback? onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUpcoming = appointment.status == AppointmentStatus.BOOKED;
    
    final dateStr = DateFormat('d MMM yyyy').format(appointment.startTime);
    final timeStr = DateFormat('jm').format(appointment.startTime);

    final statusColor = isUpcoming ? const Color(0xFF5E9EA0) : Colors.blueGrey.shade50;
    final statusTextColor = isUpcoming ? Colors.white : const Color(0xFF5E9EA0);
    final statusText = isUpcoming ? "BOOKED" : appointment.status.name;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade200,
                    
                    backgroundImage: NetworkImage(appointment.doctorImage),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctorName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment.specialty,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                        if (isUpcoming) ...[
                          const SizedBox(height: 4),
                          Text("$dateStr • $timeStr", style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                        ]
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(statusText, style: TextStyle(color: statusTextColor, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}