import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:veersa_health/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/device/device_utility.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Align(
      alignment: Alignment.bottomCenter,

      child: Padding(
        padding:  EdgeInsets.only(bottom: DeviceUtility.getBottomNavigationBarHeight() - 25,),
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: ExpandingDotsEffect(
            dotWidth: 6,
            activeDotColor: ColorConstants.primaryBrandColor,
            dotHeight: 6,
            expansionFactor: 2
          ),
        ),
      ),
    );
  }
}
