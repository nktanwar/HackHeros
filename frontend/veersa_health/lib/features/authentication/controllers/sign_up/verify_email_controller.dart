import 'dart:async';
import 'package:get/get.dart';
import 'package:veersa_health/data/repository/authentication_repository.dart';
import 'package:veersa_health/features/authentication/screens/sign_up/sign_up_success.dart';
import 'package:veersa_health/utils/helpers/network_manager.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/loaders/full_screen_loader.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  RxInt remainingTime = 27.obs;
  Timer? _timer;

  var otpDigits = List.filled(6, '').obs;

  final AuthenticationRepository _authRepo = Get.find();

  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments ?? "";
    if (email.isEmpty) {
      CustomLoaders.errorSnackBar(
        title: "Error",
        message: "Email not found. Please try registering again.",
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

  Future<void> verifyOTP() async {
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
          message: "Please enter a full 6-digit code",
        );
        return;
      }

      CustomFullScreenLoader.openLoadingDialog(
        "Verifying...",
        ImageStringsConstants.loadingImage,
      );

      await _authRepo.verifyEmailOtp(email, otp);

      CustomFullScreenLoader.closeLoadingDialog();

      Get.off(() => const SignUpSuccessScreen());
    } catch (e) {
      CustomFullScreenLoader.closeLoadingDialog();
      CustomLoaders.errorSnackBar(
        title: "Verification Failed",
        message: e.toString(),
      );
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

        await _authRepo.sendEmailOtp(email);

        CustomFullScreenLoader.closeLoadingDialog();
        CustomLoaders.customToast(message: "OTP Resent Successfully");
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
