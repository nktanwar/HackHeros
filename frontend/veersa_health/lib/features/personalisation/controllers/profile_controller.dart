import 'package:get/get.dart';
import 'package:veersa_health/features/authentication/screens/login/login_screen.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/popups/full_screen_loader.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final userName = "Rahul Kumar".obs;
  final userEmail = "rahul.kumar@example.com".obs;
  final userPhone = "+91 98765 43210".obs;
  final userProfileImage = ImageStringsConstants.avatar5.obs; // Using existing asset

  void logout() async {
    try {
      CustomFullScreenLoader.openLoadingDialog(
        "Logging you out...",
        ImageStringsConstants.loadingImage,
      );

      await Future.delayed(const Duration(seconds: 2));

      CustomFullScreenLoader.closeLoadingDialog();

      Get.offAll(() => const LoginScreen());
      
      CustomLoaders.successSnackBar(title: "Success", message: "Logged out successfully");
      
    } catch (e) {
      CustomFullScreenLoader.closeLoadingDialog();
      CustomLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}