import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:veersa_health/data/repository/authentication_repository.dart';
import 'package:veersa_health/features/authentication/screens/password_recovery/password_reset_screen.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/loaders/full_screen_loader.dart';

class ResetPasswordOtpController extends GetxController {
  static ResetPasswordOtpController get instance => Get.find();

  final AuthenticationRepository _authRepo = Get.find();
  var otpDigits = List.filled(6, '').obs;
  late String email;

  @override
  void onInit() {
    email = Get.arguments ?? "";
    super.onInit();
  }

  void setOtpDigit(int index, String value) {
    otpDigits[index] = value;
  }

  Future<void> verifyOtp() async {
    String otp = otpDigits.join();
    try {
      if (otp.length < 6) {
        CustomLoaders.warningSnackBar(
          title: "Invalid OTP",
          message: "Enter 6 digits",
        );
        return;
      }

      CustomFullScreenLoader.openLoadingDialog(
        "Verifying...",
        ImageStringsConstants.loadingImage,
      );

      await _authRepo.verifyResetOtp(email, otp);

      CustomFullScreenLoader.closeLoadingDialog();

      Get.to(() => const PasswordResetScreen(), arguments: email);
    } catch (e) {
      debugPrint("Error =============================== $e");
      CustomFullScreenLoader.closeLoadingDialog();
      CustomLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}
