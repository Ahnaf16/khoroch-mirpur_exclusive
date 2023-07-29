import 'package:flutter/material.dart';

import 'package:khoroch/core/core.dart';
import 'package:khoroch/theme/theme.dart';

class NeuListTile extends StatelessWidget {
  const NeuListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.highLight = false,
    this.onTap,
    this.titleStyle,
    this.subtitleStyle,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool highLight;
  final Function()? onTap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    final Widget titleText = AnimatedDefaultTextStyle(
      style: titleStyle ?? context.textTheme.bodyLarge!,
      duration: kThemeChangeDuration,
      child: title ?? const SizedBox(),
    );

    final Widget subtitleText = AnimatedDefaultTextStyle(
      style: subtitleStyle ?? context.textTheme.bodyMedium!,
      duration: kThemeChangeDuration,
      child: subtitle ?? const SizedBox(),
    );
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: AppTheme.decoration(context).copyWith(
          boxShadow: !highLight
              ? null
              : [
                  BoxShadow(
                    blurRadius: 15,
                    color: context.isDark
                        ? Colors.blue.shade100
                        : Colors.blue.shade200,
                    offset: const Offset(0, 0),
                  ),
                ],
        ),
        child: Row(
          children: [
            if (leading != null) leading!,
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleText,
                subtitleText,
              ],
            ),
            const Spacer(),
            const SizedBox(width: 10),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
