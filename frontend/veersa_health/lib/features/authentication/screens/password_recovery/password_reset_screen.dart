import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/common/widgets/buttons/custom_elevated_button.dart';
import 'package:veersa_health/common/widgets/input_fields/custom_text_form_field.dart';
import 'package:veersa_health/features/authentication/controllers/password_recovery_controller/new_password_controller.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';
import 'package:veersa_health/utils/validators/validators.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewPasswordController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          style: IconButton.styleFrom(backgroundColor: ColorConstants.grey),
          onPressed: () => Get.back(),
          icon: const Icon(
            Iconsax.arrow_left,
            weight: 600,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: ColorConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Set New Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Create a strong password to keep your Veersa Health account secure.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 2 * SizeConstants.spaceBtwItems),

              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Obx(
                      () => CustomTextFormField(
                        controller: controller.passwordController,
                        label: "New Password",
                        hintText: "Enter your new password",
                        prefixIcon: Iconsax.password_check,
                        obscureText: controller.hidePassword.value,
                        validator: Validators.validatePassword,

                        suffixIcon: IconButton(
                          onPressed: () => controller.hidePassword.value =
                              !controller.hidePassword.value,
                          icon: Icon(
                            controller.hidePassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: SizeConstants.spaceBtwInputField),

                    Obx(
                      () => CustomTextFormField(
                        controller: controller.confirmPasswordController,
                        label: "Confirm Password",
                        hintText: "Re-enter your password",
                        prefixIcon: Iconsax.password_check,
                        obscureText: controller.hideConfirmPassword.value,
                        // Validate both format AND match
                        validator: (value) {
                          if (value != controller.passwordController.text) {
                            return "Passwords do not match";
                          }
                          return Validators.validatePassword(value);
                        },
                        suffixIcon: IconButton(
                          onPressed: () =>
                              controller.hideConfirmPassword.value =
                                  !controller.hideConfirmPassword.value,
                          icon: Icon(
                            controller.hideConfirmPassword.value
                                ? Iconsax.eye_slash
                                : Iconsax.eye,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 2 * SizeConstants.spaceBtwSections),

              CustomElevatedButton(
                onPressed: () => controller.resetPassword(),
                child: const Text("NEXT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
