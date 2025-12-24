import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/theme/custom_themes/app_bar_theme.dart';
import 'package:veersa_health/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:veersa_health/utils/theme/custom_themes/check_box_theme.dart';
import 'package:veersa_health/utils/theme/custom_themes/elevated_button_theme_data.dart';
import 'package:veersa_health/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:veersa_health/utils/theme/custom_themes/text_field_theme.dart';
import 'package:veersa_health/utils/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

class CustomAppTheme {
  CustomAppTheme._();
  static final appTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: "Montserrat",
    primaryColor: ColorConstants.primaryBrandColor,
    scaffoldBackgroundColor: ColorConstants.backgroundColor,
    textTheme: CustomTextTheme.textTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.elevatedButtonTheme,
    appBarTheme: CustomAppBarTheme.appBarTheme,
    bottomSheetTheme: CustomBottomSheetTheme.bottomSheetTheme,
    checkboxTheme: CustomCheckBoxTheme.checkBoxTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.outlinedButtonTheme,
    inputDecorationTheme: CustomTextFieldTheme.inputDecorationTheme,
  );
}
