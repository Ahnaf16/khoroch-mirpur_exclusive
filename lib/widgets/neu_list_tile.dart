import 'package:flutter/material.dart';
import 'package:khoroch/theme/theme.dart';

class NeuListTile extends StatelessWidget {
  const NeuListTile({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.onTap,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: AppTheme.decoration(context),
        child: Row(
          children: [
            if (leading != null) leading!,
            const SizedBox(width: 10),
            if (title != null) title!,
            const Spacer(),
            const SizedBox(width: 10),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
