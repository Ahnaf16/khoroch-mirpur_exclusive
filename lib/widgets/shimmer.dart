import 'package:flutter/material.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/neu_container.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class KShimmer extends StatelessWidget {
  const KShimmer({super.key, required this.child});

  KShimmer.card({
    super.key,
    double? height = 200,
    double? width,
  }) : child = NeuContainer(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          height: height,
          width: width,
        );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Shimmer(
          duration: const Duration(milliseconds: 2000),
          color: AppTheme.foregroundColor,
          child: child,
        ),
      ),
    );
  }
}
