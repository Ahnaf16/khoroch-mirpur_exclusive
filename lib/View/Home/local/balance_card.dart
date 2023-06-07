import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/user/local/user_card.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

import 'show_balance.dart';

class BalanceCard extends ConsumerWidget {
  final int totalExp;

  const BalanceCard({required this.totalExp, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersData = ref.watch(userListProvider);
    return usersData.when(
      error: (error, stackTrace) => const Center(child: Text('E R R O R')),
      loading: () => const Loader(isList: false),
      data: (users) {
        final totalBal = users.map((e) => e.total).sum;
        users.sort((a, b) => a.total > b.total ? 1 : 0);
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
                  ShowBalance(
                    total: totalBal,
                    title: 'TOTAL BALANCE',
                  ),
                  const KDivider(),
                  ShowBalance(
                    total: totalExp,
                    title: 'TOTAL EXPEND',
                    warn: totalExp > totalBal,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  ...users.map((user) => UserCard(user: user)),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
