import 'package:flutter/material.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/theme/theme.dart';

class ShowBalance extends StatelessWidget {
  const ShowBalance({
    super.key,
    required this.total,
    required this.title,
    this.warn = false,
  });

  final int total;
  final String title;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(letterSpacing: 3),
        ),
        Text(
          total.toCurrency,
          style: context.textTheme.titleLarge?.copyWith(
            color: warn ? AppTheme.errorColor : AppTheme.successColor,
          ),
        ),
      ],
    );
  }
}
