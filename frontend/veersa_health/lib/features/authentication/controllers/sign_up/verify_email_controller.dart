import 'dart:async';
import 'package:get/get.dart';
import 'package:veersa_health/features/authentication/screens/sign_up/sign_up_success.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  
  RxInt remainingTime = 27.obs; 
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
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

  void resendOTP() {
    if (remainingTime.value == 0) {
      CustomLoaders.customToast(message: "OTP Resent Successfully");
      startTimer();
      
    } else {
      CustomLoaders.customToast(message: "Please wait before resending.");
    }
  }

  void verifyOTP(String otp) {
    
    
    Get.to(() => const SignUpSuccessScreen());
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}