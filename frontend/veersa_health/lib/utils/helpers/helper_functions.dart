import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelperFunctions {
  HelperFunctions._();



  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop())
          ],
        );
      },
    );
  }
  
  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }
  
  // static int calculateAge(DateTime dob) {
  //   final now = DateTime.now();
  //   int age = now.year - dob.year;
  //   if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
  //     age--;
  //   }
  //   return age < 0 ? 0 : age;
  // }
}
