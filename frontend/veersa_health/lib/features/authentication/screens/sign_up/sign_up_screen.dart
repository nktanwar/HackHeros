import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/common/widgets/buttons/button_with_text.dart';
import 'package:veersa_health/features/authentication/screens/login/login_screen.dart';
import 'package:veersa_health/features/authentication/screens/sign_up/widgets/signup_form.dart';
import 'package:veersa_health/features/authentication/screens/sign_up/widgets/signup_header.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';
import 'package:veersa_health/utils/device/device_utility.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              // App logo & Title
              SizedBox(height: DeviceUtility.getAppBarHeight() + 10),
              const SignUpHeader(),
              
              const SizedBox(height: SizeConstants.spaceBtwSections),
              
              // Sign Up Form
              const SignUpForm(),
              
              const SizedBox(height: SizeConstants.spaceBtwItems),

              // Footer: Already have an account?
              ButtonWithText(
                text: "Already have an Account?",
                buttonText: "Login",
                onPressed: () => Get.off(() => const LoginScreen()),
              ),
              
              const SizedBox(height: SizeConstants.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}