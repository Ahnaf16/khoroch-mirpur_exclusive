import 'package:flutter/material.dart';
import 'package:khoroch/theme/theme.dart';

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KAppBar({
    super.key,
    required this.title,
    this.actions,
  }) : preferredSize = const Size.fromHeight(100);

  @override
  final Size preferredSize;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(85),
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        decoration: AppTheme.neuDecoration.copyWith(
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: AppBar(
          automaticallyImplyLeading: false,
          clipBehavior: Clip.none,
          title: Text(title),
          actions: actions,
        ),
      ),
    );
  }
}
