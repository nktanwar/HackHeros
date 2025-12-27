import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:veersa_health/data/service/api_service.dart';
import 'package:veersa_health/data/service/notification_service.dart';
import 'package:veersa_health/features/authentication/models/auth_model.dart';
import 'package:veersa_health/features/authentication/screens/login/login_screen.dart';
import 'package:veersa_health/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:veersa_health/features/home/screens/home/home_screen.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService();
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

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
        data: requestModel.toJson(),
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
        debugPrint("=======responseCode:${response.statusCode} ");
        return;
      } else {
        debugPrint("=======responseCode:${response.statusCode} ");
        throw "Registration failed: ${response.data['message'] ?? 'Unknown error'}";
      }
    } catch (e) {
      debugPrint("Error:::::: ${e.toString()} ");
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

  Future<void> verifyEmailOtp(String email, String otp) async {
    try {
      final response = await _apiService.post(
        '/api/auth/verify-email-otp',
        data: {'email': email, 'otp': otp},
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
      String? token = await _notificationService.getDeviceToken();

      if (token != null) {
        await _apiService.post(
          '/api/devices/register',
          data: {"token": token},
        );
        debugPrint("FCM Token Registered with Backend: $token");
      }
    } catch (e) {
      debugPrint("Failed to register FCM token: $e");
    }
}

  Future<void> logout() async {
    await deviceStorage.remove('ACCESS_TOKEN');
    Get.offAll(() => const LoginScreen());
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        '/api/auth/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      if (e.toString().contains('500')) {
        throw "Server error. Please check if the email exists or try again later.";
      }
      throw e.toString();
    }
  }

  Future<void> verifyResetOtp(String email, String otp) async {
    try {
      final response = await _apiService.post(
        '/api/auth/verify-reset-otp',
        data: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw "Invalid OTP or Expired";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      final response = await _apiService.post(
        '/api/auth/reset-password',
        data: {'email': email, 'newPassword': newPassword},
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw "Failed to update password.";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
