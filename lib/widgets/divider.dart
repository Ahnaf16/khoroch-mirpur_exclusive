import 'package:flutter/material.dart';
import 'package:khoroch/core/extensions.dart';

class KDivider extends StatelessWidget {
  const KDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isLarge = context.width > 400;
    return Container(
      height: isLarge ? 50 : 3,
      width: isLarge ? 3 : 50,
      color: Colors.grey.shade500,
    );
  }
}
