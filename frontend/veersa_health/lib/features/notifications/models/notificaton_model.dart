import 'package:flutter/material.dart';

enum NotificationType {
  APPOINTMENT_CONFIRMATION,
  APPOINTMENT_REMINDER,
  GENERAL,
}

class NotificationModel {
  final String id;
  final String appointmentId;
  final String userId;
  final NotificationType type;
  final DateTime scheduledAt;
  final bool sent;
  
  String? mapUrl;
  NotificationModel({
    required this.id,
    required this.appointmentId,
    required this.userId,
    required this.type,
    required this.scheduledAt,
    required this.sent,
    this.mapUrl,
  });

  static NotificationType _parseType(String? type) {
    switch (type) {
      case 'APPOINTMENT_CONFIRMATION':
        return NotificationType.APPOINTMENT_CONFIRMATION;
      case 'APPOINTMENT_REMINDER':
        return NotificationType.APPOINTMENT_REMINDER;
      default:
        return NotificationType.GENERAL;
    }
  }

factory NotificationModel.fromJson(Map<String, dynamic> json) {
  String? findMapUrl(Map<String, dynamic> json) {
    if (json['mapUrl'] != null && json['mapUrl'].toString().isNotEmpty) {
      return json['mapUrl'];
    }
    if (json['data'] != null && json['data'] is Map) {
      final data = json['data'];
      if (data['mapUrl'] != null) return data['mapUrl'];
    }
    return null;
  }

    debugPrint("RAW JSON for Notification ${json['id']}: $json");

  return NotificationModel(
    id: json['id']?.toString() ?? '',
    appointmentId: json['appointmentId']?.toString() ?? '',
    userId: json['userId']?.toString() ?? '',
    type: _parseType(json['type']),
    scheduledAt: json['scheduledAt'] != null 
          ? DateTime.parse(json['scheduledAt']) 
          : DateTime.now(),
    sent: json['sent'] ?? false,
    mapUrl: findMapUrl(json), 
  );
  }
}
