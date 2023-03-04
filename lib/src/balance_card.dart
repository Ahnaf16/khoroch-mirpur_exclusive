import 'package:flutter/material.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/theme/theme.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(20),
      decoration: AppTheme.neuDecoration,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'BALANCE',
            style: context.textTheme.titleLarge?.copyWith(
              letterSpacing: 3,
            ),
          ),
          Text(
            30000.toCurrency,
            style: context.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
