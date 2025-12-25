import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/features/authentication/screens/login/login_screen.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();
  //Variable
  Rx<int> currentPageIndex = 0.obs;
  //Update Current Index when page scroll
  final deviceStorage = GetStorage();
  final pageController = PageController();
  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  //Jump to the specific dot selected page
  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  //Update Current Index and Jump to next Page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      deviceStorage.write('isFirstTime', false);
      Get.offAll(LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  //Update current Index and Jump to the last Page
  void skipPage() {
    deviceStorage.write('isFirstTime', false);
    Get.offAll(LoginScreen());
  }
}
