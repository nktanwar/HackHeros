import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';
import 'package:veersa_health/utils/constants/text_string_constant.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(ImageStringsConstants.appIcon),
          height: 100,
          width: 100,
        ),
        const SizedBox(height: SizeConstants.spaceBtwSections + 18),
        //Login Title and subtitle
        Text(
          TextStringsConstants.loginTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24 
          ),
        ),
        const SizedBox(height: SizeConstants.spaceBtwItems / 4),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: SizeConstants.defaultSpace),
          child: Text(
            textAlign: TextAlign.center,
            TextStringsConstants.loginSubTitle,
            style: TextStyle(fontSize: 16, 
            fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }
}
