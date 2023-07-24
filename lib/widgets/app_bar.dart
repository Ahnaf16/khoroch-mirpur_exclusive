import 'package:flutter/material.dart';
import 'package:khoroch/theme/theme.dart';

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  }) : preferredSize = const Size.fromHeight(100);

  @override
  final Size preferredSize;
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        clipBehavior: Clip.none,
        height: 100,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        decoration: AppTheme.decoration(context).copyWith(
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: AppBar(
          clipBehavior: Clip.none,
          leading: leading,
          title: Text(title),
          actions: actions,
        ),
      ),
    );
  }
}
