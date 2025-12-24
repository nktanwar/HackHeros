import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';

class CustomTextFieldTheme {
  CustomTextFieldTheme._();

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3, // Keep as is, good practice for errors
    prefixIconColor: ColorConstants.secondaryText, // Default icon color (medium grey)
    suffixIconColor: ColorConstants.secondaryText, // Default icon color (medium grey)
    fillColor: ColorConstants.whiteBackground,
    
    filled: true,
    // contentPadding: EdgeInsets.all(SizeConstants.defaultSpace),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    
    labelStyle: const TextStyle().copyWith(
      fontSize: SizeConstants.fontSizeMd,// Slightly larger, more readable label
      fontWeight: FontWeight.w600,
      color: ColorConstants.primaryTextColor, // Medium grey for labels
    ),
    // Hint Text Style
    hintStyle: const TextStyle().copyWith(
      fontSize: SizeConstants.fontSizeMd, // Consistent with label
      color: ColorConstants.secondaryText, // Lighter hint text
    ),
    // Error Text Style
    errorStyle: const TextStyle().copyWith(
      fontStyle: FontStyle.normal, // Keep as normal
      color: ColorConstants.obeseRed, // Red for errors
      fontFamily: "Montserrat",
      fontSize: SizeConstants.fontSizeSm, // Smaller for error messages
    ),
    // Floating Label Style (when input is focused and label floats)
    floatingLabelStyle: const TextStyle().copyWith(
      color: ColorConstants.secondaryText, // Blue when floating
      fontSize: SizeConstants.fontSizeSm, // Smaller when floating
    ),

    // Default Border (for unfocused, non-error state)
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizeConstants.inputFieldRadius), // Use constant for radius
      borderSide: const BorderSide(
        width: 1,
        color: ColorConstants.grey, // Light grey border
      ),
    ),
    // Enabled Border (same as default, for when input is enabled but not focused)
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizeConstants.inputFieldRadius),
      borderSide: const BorderSide(
        width: 1,
        color: ColorConstants.grey,
      ),
    ),
    // Focused Border (when input field is selected)
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizeConstants.inputFieldRadius),
      borderSide: const BorderSide(
        width: 2, // Slightly thicker border when focused
        color: ColorConstants.primaryBrandColor, // Blue border when focused
      ),
    ),

    // Error Border (when input has an error)
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizeConstants.inputFieldRadius),
      borderSide: const BorderSide(
        width: 1,
        color: ColorConstants.obeseRed, // Red border for error
      ),
    ),

    // Focused Error Border (when input has an error AND is focused)
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SizeConstants.inputFieldRadius),
      borderSide: const BorderSide(
        width: 2, // Thicker red border for focused error
        color: ColorConstants.obeseRed,
      ),
    ),
  );
  
}
