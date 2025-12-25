import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/common/widgets/buttons/button_with_text.dart';
import 'package:veersa_health/features/authentication/screens/login/widgets/login_form.dart';
import 'package:veersa_health/features/authentication/screens/login/widgets/login_header.dart';
import 'package:veersa_health/features/authentication/screens/sign_up/sign_up_screen.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';
import 'package:veersa_health/utils/device/device_utility.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorConstants.backgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //App logo
              SizedBox(height: DeviceUtility.getAppBarHeight() + 10),
              const LoginHeader(),
              const SizedBox(height: SizeConstants.spaceBtwSections + 18),
              // Login From
              const LoginForm(),
              const SizedBox(height: SizeConstants.spaceBtwItems),
              
              //Create Account
              ButtonWithText(
                text: "Don't have an Account?",
                buttonText: "Create Account",
                onPressed: () => Get.to(() => const SignUpScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}