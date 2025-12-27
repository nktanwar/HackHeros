import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:veersa_health/common/widgets/buttons/custom_elevated_button.dart';
import 'package:veersa_health/features/authentication/controllers/password_recovery_controller/reset_password_otp_controller.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';

class ResetPasswordOtpScreen extends StatelessWidget {
  const ResetPasswordOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller
    final controller = Get.put(ResetPasswordOtpController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          style: IconButton.styleFrom(backgroundColor: ColorConstants.grey),
          onPressed: () => Get.back(),
          icon: const Icon(Iconsax.arrow_left, weight: 600, color: Colors.black),
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
              
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Verify Email Address",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "A 6 digit code has been sent to:",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.email, 
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 150,
                      child: Image(
                        image: AssetImage(ImageStringsConstants.enterOtp),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              const Text(
                "Enter the verification code here",
                style: TextStyle(
                  fontSize: 16,
                  color: ColorConstants.primaryTextColor,
                ),
              ),
              const SizedBox(height: 16),
              
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: size.width * 0.12,
                    height: 50,
                    child: TextFormField(
                      onChanged: (value) {
                        controller.setOtpDigit(index, value);
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 30),
              
              // Timer and Resend Logic
              Obx(() => Text(
                  controller.remainingTime.value > 0
                      ? "Resend in 00:${controller.remainingTime.value.toString().padLeft(2, '0')}"
                      : "Did not receive code?",
                  style: const TextStyle(fontSize: 14, color: ColorConstants.primaryTextColor),
              )),
              
              const SizedBox(height: 16),
              
              InkWell(
                onTap: () => controller.resendOTP(),
                child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: const [
                     Icon(
                       Iconsax.message_notif,
                       color: ColorConstants.secondaryText,
                       size: 20,
                     ),
                     SizedBox(width: 8),
                     Text(
                       "Resend OTP",
                       style: TextStyle(
                         fontSize: 16,
                         color: ColorConstants.secondaryText,
                         fontWeight: FontWeight.w500,
                       ),
                     ),
                   ],
                ),
              ),

              const SizedBox(height: 2 * SizeConstants.spaceBtwSections),
              
              // Verify Button
              CustomElevatedButton(
                onPressed: () => controller.verifyOtp(), 
                child: const Text("Validate OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}