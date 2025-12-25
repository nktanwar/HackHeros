import 'package:flutter/material.dart';
import 'package:veersa_health/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Positioned(
      top: SizeConstants.defaultSpace - 10,
      right: SizeConstants.defaultSpace - 16,
      child: TextButton(
        onPressed: controller.skipPage,
        child: Text(
          "SKIP",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: ColorConstants.primaryBrandColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
