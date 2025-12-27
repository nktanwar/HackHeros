import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veersa_health/features/notifications/controllers/notification_controller.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('User declined permission');
      return;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleRedirection(response.payload!);
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground Message Received: ${message.data}");
      _showNotificationFromData(message, _localNotifications);
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null && message.data['mapUrl'] != null) {
        Future.delayed(const Duration(seconds: 1), () {
          _handleRedirection(message.data['mapUrl']);
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['mapUrl'] != null) {
        _handleRedirection(message.data['mapUrl']);
      }
    });
  }

  void _showNotificationFromData(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin fln,
  ) {
    if (Get.isRegistered<NotificationController>()) {
      final controller = Get.find<NotificationController>();
      controller.markAsUnread();
      controller.fetchNotifications();
    }
    final Map<String, dynamic> data = message.data;
    if (data.isEmpty) return;

    String title = "New Health Update";
    String body = "You have a new appointment update.";

    String type = data['type'] ?? 'GENERAL';
    if (type == 'APPOINTMENT_REMINDER') {
      title = "Appointment Reminder";
      body = "Tap to view your appointment location.";
    } else if (type == 'APPOINTMENT_CONFIRMATION') {
      title = "Appointment Confirmed";
      body = "Your doctor appointment is confirmed.";
    }

    fln.show(
      message.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      payload: data['mapUrl'],
    );
  }

  static void _handleRedirection(String mapUrl) async {
    if (mapUrl.isEmpty) return;
    final Uri uri = Uri.parse(mapUrl);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      debugPrint("Could not open map: $e");
      Get.snackbar("Error", "Could not open Maps direction.");
    }
  }

  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }
}
