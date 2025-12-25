import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/common/widgets/buttons/custom_elevated_button.dart';
import 'package:veersa_health/common/widgets/input_fields/custom_text_form_field.dart';
import 'package:veersa_health/features/authentication/controllers/sign_up/sign_up_controller.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';
import 'package:veersa_health/utils/constants/text_string_constant.dart';
import 'package:veersa_health/utils/validators/validators.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    
    return Form(
      key: controller.formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeConstants.defaultSpace,
        ),
        child: Column(
          children: [
            // Full Name
            CustomTextFormField(
              controller: controller.fullNameController,
              label: "Full Name",
              prefixIcon: Iconsax.user,
              hintText: "Enter your full name",
              validator: (value) => Validators.validateEmptyText("Full Name", value),
            ),
            const SizedBox(height: SizeConstants.spaceBtwInputField),

            // Email
            CustomTextFormField(
              controller: controller.emailController,
              label: "Email Address",
              prefixIcon: Iconsax.direct,
              hintText: "youremail@gmail.com",
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.validateEmail(value),
            ),
            const SizedBox(height: SizeConstants.spaceBtwInputField),

            // Mobile Number
            CustomTextFormField(
              controller: controller.mobileNumberController,
              label: "Mobile Number",
              prefixIcon: Iconsax.call,
              hintText: "Enter your mobile number",
              keyboardType: TextInputType.phone,
              validator: (value) => Validators.validatePhoneNumber(value),
            ),
            const SizedBox(height: SizeConstants.spaceBtwInputField),

            // Password
            Obx(
              () => CustomTextFormField(
                controller: controller.passwordController,
                label: "Password",
                prefixIcon: Iconsax.password_check,
                hintText: "Create your Password",
                obscureText: !controller.showPassword.value,
                suffixIcon: InkWell(
                  onTap: controller.togglePasswordVisibility,
                  child: Icon(
                    controller.showPassword.value ? Iconsax.eye : Iconsax.eye_slash,
                  ),
                ),
                validator: (value) => Validators.validatePassword(value),
              ),
            ),
            const SizedBox(height: SizeConstants.spaceBtwInputField),

            // Confirm Password
            Obx(
              () => CustomTextFormField(
                controller: controller.confirmPasswordController,
                label: "Confirm Password",
                prefixIcon: Iconsax.password_check,
                hintText: "Confirm your password",
                obscureText: !controller.showConfirmPassword.value,
                suffixIcon: InkWell(
                  onTap: controller.toggleConfirmPasswordVisibility,
                  child: Icon(
                    controller.showConfirmPassword.value ? Iconsax.eye : Iconsax.eye_slash,
                  ),
                ),
                validator: (value) {
                  if (value != controller.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: SizeConstants.spaceBtwItems),

            // Terms and Conditions Checkbox
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Obx(
                    () => Checkbox(
                      value: controller.privacyPolicy.value,
                      onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value,
                    ),
                  ),
                ),
                const SizedBox(width: SizeConstants.spaceBtwItems / 2),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: TextStringsConstants.iAgreeTo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: TextStringsConstants.termsOfservice,
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                                color: ColorConstants.primaryBrandColor,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: TextStringsConstants.privacyPolicy,
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                                color: ColorConstants.primaryBrandColor,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: SizeConstants.spaceBtwSections),

            // NEXT Button
            CustomElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text("NEXT"),
            ),
          ],
        ),
      ),
    );
  }
}