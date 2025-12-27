import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:veersa_health/utils/constants/color_constants.dart';

class CustomShimmerEffect extends StatelessWidget {
  const CustomShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.radius = 15,
    this.color,
  });

  final double width, height, radius;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:  Colors.grey[300]!,
      highlightColor:  Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color:ColorConstants.white,
          borderRadius: BorderRadius.circular(radius),
        ),
        ),
    );
  }
}
