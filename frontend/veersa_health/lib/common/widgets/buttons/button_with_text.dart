import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/device/device_utility.dart';

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    this.text,
    this.buttonText,
    this.textColor = ColorConstants.primaryTextColor,
    this.onPressed
  });
  final String? text;
  final String? buttonText;
  final Color? textColor;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.only(top: 24,bottom:DeviceUtility.getBottomNavigationBarHeight()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$text",
              style: TextStyle(fontWeight: FontWeight.w400, color: textColor),
            ),
            const SizedBox(width: 4),
            OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.all(0),
                side:  BorderSide(
                  color: ColorConstants.primaryBrandColor, // Blue border
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    6,
                  ), // Consistent border radius
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "$buttonText",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: ColorConstants.primaryBrandColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
