import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/services/sheets_api.dart';
import 'package:khoroch/theme/theme.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersColl = ref.watch(usersCashCollectionProvider);
    final usersCollApi = ref.read(usersCashCollectionProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(20),
      decoration: AppTheme.neuDecoration,
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'TOTAL BALANCE',
                    style: context.textTheme.titleMedium?.copyWith(
                      letterSpacing: 3,
                    ),
                  ),
                  Text(
                    usersCollApi.getTotalBalance.toCurrency,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Colors.green.shade300,
                    ),
                  ),
                ],
              ),
              Container(
                height: 50,
                width: 3,
                color: Colors.grey.shade500,
              ),
              Column(
                children: [
                  Text(
                    'TOTAL SPENT',
                    style: context.textTheme.titleMedium?.copyWith(
                      letterSpacing: 3,
                    ),
                  ),
                  Text(
                    30000.toCurrency,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Colors.red.shade300,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...List.generate(
                usersColl.length,
                (index) => PersonCashCard(
                  amount: usersColl[index].total,
                  name: usersColl[index].name,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class PersonCashCard extends StatelessWidget {
  const PersonCashCard({
    super.key,
    required this.amount,
    required this.name,
  });

  final int amount;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: AppTheme.neuDecoration.copyWith(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded),
          ),
          const SizedBox(height: 10),
          Text(name, style: context.textTheme.bodyLarge),
          // const SizedBox(height: 10),
          Text(amount.toCurrency, style: context.textTheme.titleLarge),
        ],
      ),
    );
  }
}
