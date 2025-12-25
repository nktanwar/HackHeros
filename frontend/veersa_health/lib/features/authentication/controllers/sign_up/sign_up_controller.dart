import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/features/authentication/screens/sign_up/verify_email_screen.dart';
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

  
  void signup() async {
    try {
      
      // if (!formKey.currentState!.validate()) return;

      
      if (!privacyPolicy.value) {
        CustomLoaders.customToast(message: 'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.');
        return;
      }

      
      CustomFullScreenLoader.openLoadingDialog(
        "We are processing your information...",
        ImageStringsConstants.loadingImage, 
      );

      
      await Future.delayed(const Duration(seconds: 2));
      
      
      CustomFullScreenLoader.closeLoadingDialog();

      
      Get.to(() => const VerifyEmailScreen());

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