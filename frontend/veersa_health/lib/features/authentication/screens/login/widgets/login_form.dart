import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/common/widgets/buttons/custom_elevated_button.dart';
import 'package:veersa_health/common/widgets/input_fields/custom_text_form_field.dart';
import 'package:veersa_health/features/authentication/controllers/login/login_controller.dart';
import 'package:veersa_health/features/authentication/screens/password_recovery/forget_password_screen.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';
import 'package:veersa_health/utils/validators/validators.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      // key: controller.formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeConstants.defaultSpace,
        ),
        child: Column(
          children: [
            CustomTextFormField(
              controller: controller.emailController,
              label: "Email Address",
              prefixIcon: Iconsax.sms,
              hintText: "youremail@example.com",
              validator: (email) => Validators.validateEmail(email),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: SizeConstants.spaceBtwInputField),
            Obx(
              () => CustomTextFormField(
                controller: controller.passwordController,
                label: "Password",
                suffixIcon: InkWell(
                  onTap: controller.togglePasswordVisibility,
                  child: controller.showPassword.value
                      ? Icon(Iconsax.eye)
                      : Icon(Iconsax.eye_slash),
                  
                ),

                hintText: "Enter your password",
                prefixIcon: Iconsax.password_check,
                obscureText: !controller.showPassword.value,
                obscuringCharacter: "*",
                validator: Validators.validatePassword,
              ),
            ),
            //Remember Me and Forget Passoword button
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => 
                        Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) =>
                              controller.rememberMe.value = value!,
                        ),
                      ),
                      Text(
                        "Remember Me",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed:
                     () => Get.to(() => const ForgetPasswordScreen()),
                    child: Text(
                      "Forget Password?",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color:  ColorConstants.primaryBrandColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SizeConstants.spaceBtwSections,),
            //Sign In button
            CustomElevatedButton(
              onPressed: ()=>controller.signIn(),
              child: const Text("LOGIN"),
            ),
          ],
        ),
      ),
    );
  }
}
