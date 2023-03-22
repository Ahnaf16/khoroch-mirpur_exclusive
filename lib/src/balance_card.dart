import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/services/firebase/users_info_api.dart';
import 'package:khoroch/theme/theme.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersData = ref.watch(usersProvider);
    return usersData.when(
      data: (users) {
        final total =
            users.fold(0, (previous, element) => previous + element.total);
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(20),
          decoration: AppTheme.neuDecoration,
          alignment: Alignment.center,
          child: Column(
            children: [
              OverflowBar(
                alignment: MainAxisAlignment.spaceEvenly,
                overflowAlignment: OverflowBarAlignment.center,
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
                        total.toCurrency,
                        style: context.textTheme.titleLarge?.copyWith(
                          color: Colors.green.shade300,
                        ),
                      ),
                    ],
                  ),
                  if (context.width > 400)
                    Container(
                      height: 50,
                      width: 3,
                      color: Colors.grey.shade500,
                    )
                  else
                    Container(
                      height: 3,
                      width: 50,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.grey.shade500,
                    ),
                  Column(
                    children: [
                      Text(
                        'TOTAL EXPEND',
                        style: context.textTheme.titleMedium?.copyWith(
                          letterSpacing: 3,
                        ),
                      ),
                      Text(
                        30000.toCurrency, // todo
                        style: context.textTheme.titleLarge?.copyWith(
                          color: Colors.red.shade300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  ...List.generate(
                    users.length,
                    (index) => PersonCashCard(
                      amount: users[index].total,
                      name: users[index].name,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
      error: (error, stackTrace) => const Text('E R R O R'),
      loading: () => const Loader(),
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LinearProgressIndicator(
        backgroundColor: AppTheme.defContentColor,
        color: AppTheme.backgroundColor,
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
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
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
        ),
      ],
    );
  }
}
