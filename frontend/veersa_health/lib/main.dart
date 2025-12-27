import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:veersa_health/bindings/general_bindings.dart';
import 'package:veersa_health/data/repository/authentication_repository.dart';
import 'package:veersa_health/data/service/notification_service.dart';
import 'package:veersa_health/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:veersa_health/utils/theme/theme.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  _showNotificationFromData(message, flutterLocalNotificationsPlugin);
}

void _showNotificationFromData(
  RemoteMessage message,
  FlutterLocalNotificationsPlugin fln,
) {
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
      iOS: DarwinNotificationDetails(presentSound: true),
    ),
    payload: data['mapUrl'],
  );
}

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  Get.put(OnBoardingController());

  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  await GetStorage.init();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBWJgkaivBNCMzWAHWSLGN4LBZaBubtfxc",
      appId: "1:1085093547710:android:6504a892799d33432758ef",
      messagingSenderId: "1085093547710",
      projectId: "healthapp-a449d",
      storageBucket: "healthapp-a449d.firebasestorage.app",
    ),
  );

  await NotificationService().init();
  Get.put(AuthenticationRepository());

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Veersa Health',
      initialBinding: GeneralBindings(),
      theme: CustomAppTheme.appTheme,
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
