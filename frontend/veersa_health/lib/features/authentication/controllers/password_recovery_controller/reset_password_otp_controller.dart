import 'dart:async';
import 'package:get/get.dart';
import 'package:veersa_health/data/repository/authentication_repository.dart';
import 'package:veersa_health/features/authentication/screens/password_recovery/password_reset_screen.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/loaders/full_screen_loader.dart';
import 'package:veersa_health/utils/helpers/network_manager.dart';

class ResetPasswordOtpController extends GetxController {
  static ResetPasswordOtpController get instance => Get.find();

  final AuthenticationRepository _authRepo = Get.find();
  var otpDigits = List.filled(6, '').obs;
  RxInt remainingTime = 27.obs;
  Timer? _timer;
  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments ?? "";
    if (email.isEmpty) {
      CustomLoaders.errorSnackBar(
        title: "Error", 
        message: "Email not found. Please try again."
      );
    }
    startTimer();
  }

  void startTimer() {
    remainingTime.value = 27;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void setOtpDigit(int index, String value) {
    otpDigits[index] = value;
  }

  Future<void> verifyOtp() async {
    String otp = otpDigits.join();
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CustomLoaders.customToast(message: 'No internet connection.');
        return;
      }

      if (otp.length < 6) {
        CustomLoaders.warningSnackBar(
          title: "Invalid OTP",
          message: "Please enter the full 6-digit code",
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
      CustomFullScreenLoader.closeLoadingDialog();
      CustomLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }

  Future<void> resendOTP() async {
    if (remainingTime.value == 0) {
      try {
        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          CustomLoaders.customToast(message: 'No internet connection.');
          return;
        }

        CustomFullScreenLoader.openLoadingDialog(
          "Resending OTP...",
          ImageStringsConstants.loadingImage,
        );

        await _authRepo.forgotPassword(email);

        CustomFullScreenLoader.closeLoadingDialog();
        CustomLoaders.successSnackBar(
          title: "OTP Resent",
          message: "A new code has been sent to your email."
        );
        
        startTimer();
      } catch (e) {
        CustomFullScreenLoader.closeLoadingDialog();
        CustomLoaders.errorSnackBar(
          title: "Something went wrong!",
          message: "Error in re-sending otp. Try after some time.",
        );
      }
    } else {
      CustomLoaders.customToast(message: "Please wait before resending.");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}