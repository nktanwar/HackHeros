import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/common/widgets/buttons/custom_elevated_button.dart';
import 'package:veersa_health/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:veersa_health/utils/device/device_utility.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Obx(
        () => Container(
          padding: EdgeInsets.only(
            bottom: DeviceUtility.getBottomNavigationBarHeight() + 8,
            left: 24,
            right: 24,
          ),
          child: CustomElevatedButton(
            onPressed: controller.nextPage,
            child: controller.currentPageIndex.value <= 1
                ? Text("NEXT")
                : Text("Get Started"),
          ),
        ),
      ),
    );
  }
}
