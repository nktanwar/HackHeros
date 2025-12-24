import 'package:flutter/material.dart';

class CustomTextTheme {
  CustomTextTheme._();

  static final textTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 24,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 18,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 14,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 14,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w500,
      color: Colors.black.withAlpha(127),
    ),
    labelLarge: const TextStyle().copyWith(
      fontSize: 12,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.normal,
      color:Colors.black.withAlpha(127),
    ),
  );
}
