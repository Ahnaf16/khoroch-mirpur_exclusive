import 'package:flutter/material.dart';
import 'package:khoroch/theme/theme.dart';

class NeuButton extends StatelessWidget {
  const NeuButton({
    super.key,
    required this.onTap,
    this.showLoading = false,
    required this.child,
    this.height,
    this.width,
  });

  NeuButton.social({
    super.key,
    required this.onTap,
    required this.showLoading,
    required IconData icon,
    required String socialName,
    this.height,
    this.width,
  }) : child = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              socialName,
              style: AppTheme.textTheme().titleSmall?.copyWith(fontSize: 18),
            )
          ],
        );

  final Function()? onTap;
  final bool showLoading;
  final Widget child;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            clipBehavior: Clip.none,
            decoration: AppTheme.neuDecoration,
            alignment: Alignment.center,
            height: height ?? 50,
            width: width,
            child: child,
          ),
        ),
        if (showLoading) const SizedBox(height: 10),
        if (showLoading) const LinearProgressIndicator(),
      ],
    );
  }
}
