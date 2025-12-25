import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class SectionHeadingWithButton extends StatelessWidget {
  const SectionHeadingWithButton({
    super.key,
    this.isButtonVisible = false,
    required this.sectionHeading,
    this.buttonText = "View All",
    this.onPressed,
    this.textColor
  });

  final bool isButtonVisible;
  final String sectionHeading;
  final void Function()? onPressed;
  final String buttonText;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sectionHeading,
           style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (isButtonVisible)
          TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorConstants.primaryBrandColor
          ),
            ),
          ),
      ],
    );
  }
}
