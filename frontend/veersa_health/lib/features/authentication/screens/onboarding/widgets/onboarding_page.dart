import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';
import 'package:veersa_health/utils/helpers/helper_functions.dart';

class OnBoardingPage extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? image;

  const OnBoardingPage({
    super.key,
    this.image,
    this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeConstants.defaultSpace,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Image(
              height: 0.55 * HelperFunctions.screenHeight(), 
              width: 0.6 * HelperFunctions.screenWidth(),
              image: AssetImage(image!),
            ),
            const SizedBox(height: SizeConstants.spaceBtwItems / 2), 
            Text(
              title!,
              textAlign: TextAlign.center, 
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: ColorConstants.primaryTextColor,
                    height: 1.1, 
                  ),
            ),
            const SizedBox(height: SizeConstants.spaceBtwItems), 
            Text(
              subTitle!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: ColorConstants.primaryTextColor,
                    height: 1.2, 
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
