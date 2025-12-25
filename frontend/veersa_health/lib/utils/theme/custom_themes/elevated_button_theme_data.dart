import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';

class CustomElevatedButtonTheme {
  CustomElevatedButtonTheme._();

  

  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: SizeConstants.buttonElevation, 
      backgroundColor: ColorConstants.primaryBrandColor, 
      foregroundColor: ColorConstants.cardBackgroundColor, 
      
      disabledBackgroundColor: ColorConstants.secondaryText.withAlpha(127),
      disabledForegroundColor: ColorConstants.white.withAlpha(127),
      side: BorderSide.none, 
      textStyle:  const TextStyle(
      fontSize: 20,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConstants.borderRadiusLg), 
      ),
    ),
  );
}