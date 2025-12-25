enum NotificationType { APPOINTMENT_CONFIRMATION, APPOINTMENT_REMINDER, GENERAL }

class NotificationModel {
  final String id;
  final String appointmentId;
  final String userId;
  final NotificationType type;
  final DateTime scheduledAt;
  final bool sent;

  // Constructor
  NotificationModel({
    required this.id,
    required this.appointmentId,
    required this.userId,
    required this.type,
    required this.scheduledAt,
    required this.sent,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      appointmentId: json['appointmentId'] ?? '',
      userId: json['userId'] ?? '',
      type: _parseType(json['type']),
      scheduledAt: DateTime.parse(json['scheduledAt']),
      sent: json['sent'] ?? false,
    );
  }

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
}