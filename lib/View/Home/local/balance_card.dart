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

    final cashByUsers = ref.watch(totalCashCollectedProvider);
    return usersData.when(
      error: ErrorView.errorMathod,
      loading: () => const Loader(isList: false),
      data: (users) {
        // users.sort((a, b) => ,);
        return cashByUsers.when(
            error: ErrorView.errorMathod,
            loading: () => const Loader(),
            data: (cash) {
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
                          total: cash,
                          title: 'TOTAL BALANCE',
                        ),
                        const KDivider(),
                        ShowBalance(
                          total: totalExp,
                          title: 'TOTAL EXPEND',
                          warn: totalExp > cash,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      children: [
                        ...users.map(
                          (user) => UserCard(user: user),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            });
      },
    );
  }
}
