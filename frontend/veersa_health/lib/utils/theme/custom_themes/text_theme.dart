import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class CustomTextTheme {
  CustomTextTheme._();

  static final textTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.bold,
      color: ColorConstants.primaryTextColor,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 24,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w600,
      color: ColorConstants.primaryTextColor,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 18,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w600,
      color: ColorConstants.primaryTextColor,
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w600,
      color: ColorConstants.primaryTextColor,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w500,
      color: ColorConstants.primaryTextColor,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w400,
      color: ColorConstants.primaryTextColor,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w500,
      color: ColorConstants.primaryTextColor,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 14,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.normal,
      color: ColorConstants.primaryTextColor,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 14,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w500,
      color: ColorConstants.primaryTextColor.withAlpha(127),
    ),
    labelLarge: const TextStyle().copyWith(
      fontSize: 12,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.normal,
      color: ColorConstants.primaryTextColor,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.normal,
      color:ColorConstants.primaryTextColor.withAlpha(127),
    ),
  );
}
