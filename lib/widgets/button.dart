import 'package:flutter/material.dart';
import 'package:khoroch/theme/theme.dart';

class NeuButton extends StatelessWidget {
  const NeuButton({
    super.key,
    required this.onTap,
    required this.showLoading,
    required this.child,
  });

  NeuButton.social({
    super.key,
    required this.onTap,
    required this.showLoading,
    required IconData icon,
    required String socialName,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            clipBehavior: Clip.none,
            decoration: AppTheme.neuDecoration,
            height: 50,
            child: child,
          ),
        ),
        if (showLoading) const SizedBox(height: 10),
        if (showLoading) const LinearProgressIndicator(),
      ],
    );
  }
}
