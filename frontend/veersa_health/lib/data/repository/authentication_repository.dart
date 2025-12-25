import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veersa_health/data/service/api_service.dart';
import 'package:veersa_health/features/authentication/models/auth_model.dart';
import 'package:veersa_health/features/authentication/screens/login/login_screen.dart';
import 'package:veersa_health/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:veersa_health/features/home/screens/home/home_screen.dart'; // Assume this exists

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final ApiService _apiService = ApiService();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  // 1. Check Auth Status on App Start
  void screenRedirect() async {
    final token = deviceStorage.read('ACCESS_TOKEN');
    
    if (token != null) {
      Get.offAll(() => const HomeScreen());
    } else {
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const OnBoardingScreen());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final requestModel = LoginRequest(email: email, password: password);
      
      final response = await _apiService.post(
        '/api/auth/login', 
        data: requestModel.toJson()
      );

      if (response.statusCode == 200) {
        final authResponse = LoginResponse.fromJson(response.data);
        
        await deviceStorage.write('ACCESS_TOKEN', authResponse.accessToken);
        
        await registerFCMToken();

        Get.offAll(() => const HomeScreen());
      } else {
        throw "Login failed: ${response.statusMessage}";
      }
    } catch (e) {
      throw e.toString(); 
    }
  }

  Future<void> register(SignupRequest data) async {
    try {
      final response = await _apiService.post(
        '/api/auth/signup',
        data: data.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return; 
      } else {
        throw "Registration failed: ${response.data['message'] ?? 'Unknown error'}";
      }
    } catch (e) {
      throw e.toString();
    }
  }
  Future<void> sendEmailOtp(String email) async {
    try {
      final response = await _apiService.post(
        '/api/auth/send-email-otp',
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw "Failed to send OTP: ${response.data['message'] ?? 'Unknown error'}";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // NEW: Verify OTP
  Future<void> verifyEmailOtp(String email, String otp) async {
    try {
      final response = await _apiService.post(
        '/api/auth/verify-email-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw "Verification failed: ${response.data['message'] ?? 'Invalid OTP'}";
      }
    } catch (e) {
      throw e.toString();
    }
  }
  Future<void> registerFCMToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
        
        // 2. Get Token
        String? token = await messaging.getToken();
        
        if (token != null) {
          // 3. Send to Backend
          await _apiService.post(
            '/api/devices/register', 
            data: {"token": token},
          );
          debugPrint("FCM Token Registered: $token");
          
          // 4. Listen for Foreground Messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          _handleForegroundNotification(message);
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          _handleNotificationTap(message.data);
        });

        // 5. Handle Terminated State Tap
        FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
          if (message != null) {
            _handleNotificationTap(message.data);
          }
        });
        }
      } else {
        debugPrint('User declined or has not accepted permission');
      }
    } catch (e) {
      debugPrint("Failed to register FCM token: $e");
    }
  }

  void _handleForegroundNotification(RemoteMessage message) {
    // Determine title/body from data payload if notification block is empty (Data-only payload)
    String title = message.notification?.title ?? "New Notification";
    String body = message.notification?.body ?? "";

    if (message.data.isNotEmpty) {
      final type = message.data['type'];
      if (type == 'APPOINTMENT_REMINDER') {
        title = "Appointment Reminder";
        body = "You have an upcoming appointment. Tap to view location.";
      }
    }

    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black,
      icon: const Icon(Icons.notifications_active, color: Colors.blue),
      onTap: (_) => _handleNotificationTap(message.data), // Handle tap on snackbar
      duration: const Duration(seconds: 5),
    );
  }
  Future<void> _handleNotificationTap(Map<String, dynamic> data) async {
    if (data['mapUrl'] != null) {
      final Uri url = Uri.parse(data['mapUrl']);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not open map");
      }
    }
  }
  // 5. Logout
  Future<void> logout() async {
    await deviceStorage.remove('ACCESS_TOKEN');
    Get.offAll(() => const LoginScreen());
  }
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        '/api/users/forgot-password',
        data: {'email': email},
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw "Failed to send email: ${response.data['message'] ?? 'Unknown error'}";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // 2. Verify Reset OTP
  Future<void> verifyResetOtp(String email, String otp) async {
    try {
      final response = await _apiService.post(
        '/api/users/verify-reset-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw "Invalid OTP: ${response.data['message'] ?? 'Unknown error'}";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // 3. Reset Password
  Future<void> resetPassword(String email, String newPassword) async {
    try {
      final response = await _apiService.post(
        '/api/users/reset-password',
        data: {
          'email': email,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw "Failed to reset password: ${response.data['message'] ?? 'Unknown error'}";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}