import 'package:flutter/material.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';
import 'package:veersa_health/utils/constants/size_constants.dart';

class CustomAnimationLoader extends StatelessWidget {
  final String text;
  final String animation;
  final bool showAction;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const CustomAnimationLoader({
    super.key,
    required this.text,
    this.showAction = false,
    required this.animation,
    this.onActionPressed,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(animation),
          width: MediaQuery.of(context).size.width >= 900
              ? MediaQuery.of(context).size.width * 0.4
              : MediaQuery.of(context).size.width * 0.8,
        ),
        const SizedBox(height: SizeConstants.defaultSpace),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: SizeConstants.defaultSpace),
        showAction
            ? SizedBox(
                width: 250,
                child: OutlinedButton(
                  onPressed: onActionPressed,
                  child: Text(
                    actionText!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.apply(color: ColorConstants.black),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
