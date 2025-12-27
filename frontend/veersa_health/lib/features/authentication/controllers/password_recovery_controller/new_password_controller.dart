import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/data/repository/authentication_repository.dart';
import 'package:veersa_health/features/authentication/screens/login/login_screen.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/loaders/full_screen_loader.dart';

class NewPasswordController extends GetxController {
  static NewPasswordController get instance => Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthenticationRepository _authRepo = Get.find();

  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;

  late String email;

  @override
  void onInit() {
    email = Get.arguments ?? "";
    super.onInit();
  }

  Future<void> resetPassword() async {
    try {
      if (!formKey.currentState!.validate()) return;

      if (passwordController.text != confirmPasswordController.text) {
        CustomLoaders.warningSnackBar(
          title: "Mismatch",
          message: "Passwords do not match",
        );
        return;
      }

      CustomFullScreenLoader.openLoadingDialog(
        "Updating Password...",
        ImageStringsConstants.loadingImage,
      );

      await _authRepo.resetPassword(email, passwordController.text.trim());

      CustomFullScreenLoader.closeLoadingDialog();

      // Get.offAll(() => const PasswordSuccessScreen());
      CustomLoaders.successSnackBar(title: "Password Updated Successfully", message: "Your password has been changed. You can now log in with your new password.");
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      debugPrint("Error =============================== $e");
      CustomFullScreenLoader.closeLoadingDialog();
      CustomLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}
