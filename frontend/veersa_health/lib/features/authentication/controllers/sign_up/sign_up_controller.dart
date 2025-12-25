import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:veersa_health/data/repository/authentication_repository.dart';
import 'package:veersa_health/features/authentication/models/auth_model.dart';
import 'package:veersa_health/features/authentication/screens/sign_up/verify_email_screen.dart';
import 'package:veersa_health/utils/helpers/network_manager.dart';
import 'package:veersa_health/utils/loaders/loaders.dart'; 
import 'package:veersa_health/utils/popups/full_screen_loader.dart'; 
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  
  final privacyPolicy = false.obs;
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  final AuthenticationRepository _authRepo = Get.find();
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled. Please enable them.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    return await Geolocator.getCurrentPosition();
  }
  void signup() async {
    try {
      if (!formKey.currentState!.validate()) return;

      if (!privacyPolicy.value) {
        CustomLoaders.customToast(message: 'Accept Privacy Policy');
        return;
      }
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CustomLoaders.customToast(message: 'No internet connection.');
        return;
      }

      CustomFullScreenLoader.openLoadingDialog(
        "Getting locatoin & processing your information...",
        ImageStringsConstants.loadingImage, 
      );
      Position position = await _determinePosition();
      final newUser = SignupRequest(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: mobileNumberController.text.trim(),
        password: passwordController.text.trim(),
        role: "PATIENT",
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await _authRepo.register(newUser);
      
      CustomFullScreenLoader.closeLoadingDialog();
      Get.to(
        () => const VerifyEmailScreen(), 
        arguments: emailController.text.trim() 
      );
    } catch (e) {
      CustomFullScreenLoader.closeLoadingDialog();
      CustomLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}