import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  
  // Future<void> sendPasswordResetEmail({String? email}) async {
  //   try {
      
  //     final emailToUse = email ?? emailController.text.trim();

      
  //     if (email == null) { 
  //       if (!formKey.currentState!.validate()) {
  //         return;
  //       }
  //     }
      
  //     if (emailToUse.isEmpty) {
  //       CustomLoaders.warningSnackBar(title: "No Email", message: "Please enter your email address.");
  //       return;
  //     }

      
  //     final isConnected = await NetworkManager.instance.isConnected();
  //     if (!isConnected) {
  //       CustomLoaders.customToast(message: 'No internet connection.');
  //       return;
  //     }

      
  //     CustomFullScreenLoader.openLoadingDialog(
  //         "Sending reset link...", ImageStringsConstants.processingAnimation);

      
  //     await AuthenticationRepository.instance
  //         .sendPasswordResetEmail(emailToUse);

      
  //     CustomFullScreenLoader.closeLoadingDialog();

      
  //     CustomLoaders.successSnackBar(
  //         title: "Email Sent",
  //         message: "A link to reset your password has been sent to your email.");

      
  //     if (email == null) {
  //       Get.to(() =>
  //           ResetPasswordScreen(email: emailToUse));
  //     }
  //   } catch (e) {
  //     CustomFullScreenLoader.closeLoadingDialog();
  //     CustomLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
  //   }
  // }
}