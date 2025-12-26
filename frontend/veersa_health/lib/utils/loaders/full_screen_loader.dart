import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veersa_health/common/loaders/animation_loader.dart';

class CustomFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!, 
      barrierDismissible:
          false, 
      builder:
          (_) => PopScope(
            canPop: false, 
            child: Container(
              color:Color(0xFFbeddfa),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  CustomAnimationLoader(text: text, animation: animation),
                ],
              ),
            ),
          ),
    );
  }

  
  static void closeLoadingDialog() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
