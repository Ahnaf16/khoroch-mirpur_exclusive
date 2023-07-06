import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/user/local/user_card.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class BalanceCard extends ConsumerWidget {
  final int totalExp;

  const BalanceCard({required this.totalExp, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersData = ref.watch(userListProvider);

    return usersData.when(
      error: ErrorView.errorMathod,
      loading: () => const Loader(isList: false),
      data: (users) {
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(20),
          decoration: AppTheme.neuDecoration,
          alignment: Alignment.center,
          child: Column(
            children: [
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
      },
    );
  }
}
