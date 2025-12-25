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
  
 static String formatDate(DateTime date) {
    final time = "${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}";
    return "Date: ${date.day}/${date.month}/${date.year} at $time";
  }
}
