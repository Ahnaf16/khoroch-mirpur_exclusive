import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/Home/local/expenditure.dart';
import 'package:khoroch/View/Home/local/show_balance.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/View/Home/local/user_card.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expendData = ref.watch(expenditureProvider);
    final usersData = ref.watch(userDataProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(85),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            decoration: AppTheme.neuDecoration.copyWith(
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              'KHOROCH',
              style: context.textTheme.titleMedium?.copyWith(
                letterSpacing: 3,
              ),
            ),
          ),
        ),
        body: expendData.when(
          error: (error, stackTrace) => const Center(child: Text('E R R O R')),
          loading: () => const Loader(isList: true),
          data: (expenders) {
            final totalExp = expenders.map((e) => e.amount).sum;
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  usersData.when(
                      error: (error, stackTrace) =>
                          const Center(child: Text('E R R O R')),
                      loading: () => const Loader(isList: false),
                      data: (users) {
                        final totalBal = users.map((e) => e.total).sum;
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
                                  ...users.map(
                                      (user) => PersonCashCard(user: user)),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      }),
                  const SizedBox(height: 10),
                  Text(
                    'Expenditure',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: expenders.length,
                    itemBuilder: (BuildContext context, int index) {
                      final expend = expenders[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: AppTheme.neuDecoration,
                        child: Row(
                          children: [
                            const Icon(MdiIcons.currencyBdt),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expend.amount.toCurrency,
                                  style: context.textTheme.titleLarge,
                                ),
                                Text(
                                  expend.item,
                                  style: context.textTheme.labelLarge,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              expend.date.formateDate(),
                              style: context.textTheme.labelLarge,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: () => showAddExpanseSheet(context),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: AppTheme.neuDecoration.copyWith(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('A D D'),
                SizedBox(width: 10),
                Icon(Icons.add_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showAddExpanseSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      barrierColor: Colors.grey.withOpacity(.8),
      elevation: 30,
      backgroundColor: AppTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const AddExpanseSheet(),
    );
  }
}
