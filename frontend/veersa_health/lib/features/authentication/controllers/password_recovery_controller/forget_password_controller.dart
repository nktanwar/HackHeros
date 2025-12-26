import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/data/repository/authentication_repository.dart';
import 'package:veersa_health/features/authentication/screens/password_recovery/reset_password_otp_screen.dart';
import 'package:veersa_health/utils/helpers/network_manager.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/loaders/full_screen_loader.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final AuthenticationRepository _authRepo = Get.find();

  Future<void> sendPasswordResetEmail() async {
    try {
      if (!formKey.currentState!.validate()) return;
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CustomLoaders.customToast(message: 'No internet connection.');
        return;
      }
      CustomFullScreenLoader.openLoadingDialog(
        "Processing...",
        ImageStringsConstants.loadingImage,
      );
      await _authRepo.forgotPassword(emailController.text.trim());

      CustomFullScreenLoader.closeLoadingDialog();

      Get.to(
        () => const ResetPasswordOtpScreen(),
        arguments: emailController.text.trim(),
      );

      CustomLoaders.successSnackBar(
        title: "Email Sent",
        message: "Check your inbox for the OTP.",
      );
    } catch (e) {
      CustomFullScreenLoader.closeLoadingDialog();
      debugPrint("Error =============================== $e");
      CustomLoaders.errorSnackBar(
        title: "Oh Snap!",
        message: "Something went wrong.",
      );
    }
  }
}
