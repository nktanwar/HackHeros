import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/common/widgets/buttons/custom_elevated_button.dart';
import 'package:veersa_health/features/home/screens/home/home_screen.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 80),
                        Image.asset(
                          ImageStringsConstants.bookingSuccess,
                          height: 250,
                          width: 250,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Appointment Booked!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Your appointment has been successfully scheduled. You will receive a notification shortly.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        CustomElevatedButton(
                          onPressed: () => Get.offAll(() => const HomeScreen()),
                          child: const Text("Done"),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
