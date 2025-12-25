import 'package:flutter/material.dart';
import 'package:veersa_health/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:veersa_health/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:veersa_health/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:veersa_health/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:veersa_health/features/authentication/screens/onboarding/widgets/onboarding_smooth_dot_navigation.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/constants/text_string_constant.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Scaffold(

      body: Container(
        
        decoration: BoxDecoration(
          color: ColorConstants.backgroundColor,
          // color: Color(0xFFe3effd)
        ),
        child: Stack(
          children: [
            //Onboarding Pages
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator,
              children: [
                OnBoardingPage(
                  image: ImageStringsConstants.onBoardingImage1,
                  title: TextStringsConstants.onBoardingTitle1,
                  subTitle: TextStringsConstants.onBoardingSubTitle1,
                ),
                OnBoardingPage(
                  image: ImageStringsConstants.onBoardingImage2,
                  title: TextStringsConstants.onBoardingTitle2,
                  subTitle: TextStringsConstants.onBoardingSubTitle2,
                ),
                OnBoardingPage(
                  image: ImageStringsConstants.onBoardingImage3,
                  title: TextStringsConstants.onBoardingTitle3,
                  subTitle: TextStringsConstants.onBoardingSubTitle3,
                ),
              ],
            ),
            //Skip Text
            const OnBoardingSkip(),
            //Dot Navigation SmmothPageIndicator
            const OnBoardingDotNavigation(),
            //Circular Static Button
            const OnBoardingNextButton(),
          ],
        ),
      ),
    );
  }
}
