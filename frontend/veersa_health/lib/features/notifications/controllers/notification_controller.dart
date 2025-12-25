import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final String dateTime;
  final bool isUnread;
  final IconData? iconData;
  
  final String? doctorName;
  final String? doctorSpecialty;
  final String? clinicName;
  final String? address;
  final String? doctorAvatarUrl; 
  final bool showMap; 

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.dateTime,
    this.isUnread = false,
    this.iconData,
    this.doctorName,
    this.doctorSpecialty,
    this.clinicName,
    this.address,
    this.doctorAvatarUrl,
    this.showMap = false,
  });
}

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;

  List<NotificationModel> get unreadList => 
      notifications.where((n) => n.isUnread).toList();
      
  List<NotificationModel> get readList => 
      notifications.where((n) => !n.isUnread).toList();

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    notifications.value = [
      
      NotificationModel(
        id: '1',
        title: "Appointment Reminder",
        description: "Your appointment with Dr. Priya Sharma is scheduled for today, April 24, 2026, at 3:30 PM at HeartCare Clinic.",
        timeAgo: "1h ago",
        dateTime: "Today, 2:30 PM",
        isUnread: true,
        
        doctorName: "Dr. Priya Sharma",
        doctorSpecialty: "Cardiologist",
        clinicName: "HeartCare Clinic",
        address: "123 Health St, Suite 45, City, State, 560091",
        showMap: true, 
      ),
      NotificationModel(
        id: '2',
        title: "Confirm Your Email",
        description: "Enter the OTP sent to your registered email to verify your Veersa Health account.",
        timeAgo: "4h ago",
        dateTime: "Today, 11:45 AM",
        isUnread: true,
      ),
      NotificationModel(
        id: '3',
        title: "Appointment Confirmed",
        description: "Your appointment with Dr. Arjun Kapoor has been confirmed for April 25, 2024.",
        timeAgo: "5h ago",
        dateTime: "Today, 9:45 AM",
        isUnread: false,
        iconData: Icons.notifications_none_rounded,
      ),
    ];
  }

  void markAllAsRead() {
    var updated = notifications.map((n) {
      return NotificationModel(
        id: n.id,
        title: n.title,
        description: n.description,
        timeAgo: n.timeAgo,
        dateTime: n.dateTime,
        isUnread: false,
        iconData: n.iconData,
        doctorName: n.doctorName,
        doctorSpecialty: n.doctorSpecialty,
        clinicName: n.clinicName,
        address: n.address,
        showMap: n.showMap,
      );
    }).toList();
    notifications.assignAll(updated);
  }

  void clearAllRead() {
    notifications.removeWhere((n) => !n.isUnread);
  }
}