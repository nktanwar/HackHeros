import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';
import 'package:veersa_health/utils/constants/text_string_constant.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        
        Image(
          image: AssetImage(ImageStringsConstants.appIcon), 
          height: 150, 
          width: 150,
        ),
        const SizedBox(height: SizeConstants.spaceBtwSections),
        
        Text(
          TextStringsConstants.signupTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: ColorConstants.primaryTextColor,
          ),
        ),
        const SizedBox(height: SizeConstants.spaceBtwItems / 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConstants.defaultSpace),
          child: Text(
            TextStringsConstants.signupSubTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}