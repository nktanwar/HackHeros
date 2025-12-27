import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/common/widgets/buttons/custom_elevated_button.dart';
import 'package:veersa_health/common/widgets/input_fields/custom_text_form_field.dart';
import 'package:veersa_health/features/authentication/controllers/password_recovery_controller/forget_password_controller.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';
import 'package:veersa_health/utils/constants/text_string_constant.dart';
import 'package:veersa_health/utils/validators/validators.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      
      appBar: AppBar(
    
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: ColorConstants.grey
          ),
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Iconsax.arrow_left,weight:600, color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(SizeConstants.defaultSpace),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.left,
                TextStringsConstants.forgetPasswordTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
              ),
              const SizedBox(height: 12,),
              Text(TextStringsConstants.forgetPasswordSubTitle,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16
              ),
              ),
              SizedBox(height: 2*SizeConstants.spaceBtwItems),
              CustomTextFormField(
                controller: controller.emailController,
                label: "Email Address",
                hintText: "youremail@example.com",
                prefixIcon: Iconsax.sms,
                showOutlineBorder: true,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              SizedBox(height: 2*SizeConstants.spaceBtwSections),
              CustomElevatedButton(
                // onPressed: () {},
                onPressed: () => controller.sendPasswordResetEmail(),
                child: const Text("NEXT"),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
