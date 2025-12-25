import 'package:flutter/material.dart';
import 'package:veersa_health/features/my_appointments/models/appointment_model.dart';
import 'package:veersa_health/utils/helpers/helper_functions.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback? onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    final isUpcoming = appointment.status == AppointmentStatus.upcoming;
    
    
    final statusColor = isUpcoming 
        ? const Color(0xFF5E9EA0) 
        : Colors.blueGrey.shade50;
        
    final statusTextColor = isUpcoming 
        ? Colors.white 
        : const Color(0xFF5E9EA0); 
        
    final statusText = isUpcoming ? "UPCOMING" : "COMPLETED";

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    backgroundImage: NetworkImage(appointment.doctorImageUrl),
                    onBackgroundImageError: (_, _) {
                      
                    },
                    child: (appointment.doctorImageUrl.isEmpty) 
                        ? const Icon(Icons.person, color: Colors.grey) 
                        : null,
                  ),
                  const SizedBox(width: 12),

                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctorName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3142), 
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment.specialty,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        if (isUpcoming) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.call, size: 14, color: Color(0xFF5E9EA0)),
                              const SizedBox(width: 4),
                              Text(
                                appointment.phoneNumber,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isUpcoming) ...[
                          Icon(Icons.check, size: 14, color: statusTextColor),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              
              Divider(color: Colors.grey.shade100, thickness: 1),

              const SizedBox(height: 12),

              
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    
                    HelperFunctions.formatDate(appointment.appointmentDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  
                  if (isUpcoming)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                ],
              ),

              const SizedBox(height: 12),

              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.clinicName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          appointment.address,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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