import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:veersa_health/data/repository/authentication_repository.dart';
import 'package:veersa_health/features/home/screens/home/home_screen.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/helpers/network_manager.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/loaders/full_screen_loader.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = false.obs;
  final deviceStorage = GetStorage();
  final showPassword = false.obs;
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  final AuthenticationRepository _authRepo = AuthenticationRepository.instance;

  @override
  void onInit() {
    if (deviceStorage.read('REMEMBER_ME') ?? false) {
      emailController.text = deviceStorage.read('REMEMBER_ME_EMAIL') ?? '';
      passwordController.text =
          deviceStorage.read('REMEMBER_ME_PASSWORD') ?? '';
      rememberMe.value = true;
    }
    super.onInit();
  }

  Future<void> signIn() async {
    try {
      if (!formKey.currentState!.validate()) return;
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        CustomLoaders.customToast(message: 'No internet connection.');
        return;
      }

      CustomFullScreenLoader.openLoadingDialog(
        "Logging you in...",
        ImageStringsConstants.loadingImage,
      );

      if (rememberMe.value) {
        deviceStorage.write('REMEMBER_ME', true);
        deviceStorage.write('REMEMBER_ME_EMAIL', emailController.text.trim());
        deviceStorage.write(
          'REMEMBER_ME_PASSWORD',
          passwordController.text.trim(),
        );
      } else {
        deviceStorage.write('REMEMBER_ME', false);
        deviceStorage.remove('REMEMBER_ME_EMAIL');
        deviceStorage.remove('REMEMBER_ME_PASSWORD');
      }

      await _authRepo.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      CustomFullScreenLoader.closeLoadingDialog();
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      CustomFullScreenLoader.closeLoadingDialog();
      debugPrint("Error ===================================== $e");
      CustomLoaders.errorSnackBar(
        title: "Login Failded",
        message: "Invalid Credentials!",
      );
    }
  }
}
