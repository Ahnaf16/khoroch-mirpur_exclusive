import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/View/groups/local/expense_sheet.dart';
import 'package:khoroch/View/groups/local/expenditure_list.dart';
import 'package:khoroch/View/groups/local/info_drawer.dart';
import 'package:khoroch/View/groups/local/show_balance.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/providers/groups_provider.dart';
import 'package:khoroch/services/providers/providers.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class GroupExpanseView extends ConsumerWidget {
  const GroupExpanseView(this.groupId, {super.key});

  final String groupId;

  Future<dynamic> showAddExpanseSheet(BuildContext context, Intend intend) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddExpanseSheet(intend: intend, groupId: groupId),
    );
  }

  Intend getIntend(GroupModel group) {
    final userRole = group.roles[getUser!.uid];

    return switch (userRole) {
      null => Intend.request,
      GroupRole.viewer => Intend.request,
      GroupRole.owner => Intend.add,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expendData = ref.watch(expenditureProvider(groupId));
    final groupData = ref.watch(groupByIdProvider(groupId));

    return SafeArea(
      child: groupData.when(
        error: ErrorView.errorMathod,
        loading: () => const Loader(),
        data: (group) => Scaffold(
          appBar: KAppBar(
            title: group.name,
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(Icons.menu_rounded),
                  );
                },
              )
            ],
          ),
          endDrawer: GroupInfoDrawer(group: group),
          body: expendData.when(
            error: ErrorView.errorMathod,
            loading: () => const Loader(isList: true),
            data: (expenders) {
              final totalBal = group.cashAmount.values.sum;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(20),
                      decoration: AppTheme.decoration(context),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ShowBalance(
                                total: totalBal,
                                title: 'TOTAL BALANCE',
                              ),
                              const KDivider(),
                              ShowBalance(
                                total: group.totalExpanse,
                                title: 'TOTAL EXPEND',
                                warn: group.totalExpanse > totalBal,
                              ),
                            ],
                          ),
                          if (group.totalExpanse > totalBal)
                            const SizedBox(height: 10),
                          Visibility(
                            visible: group.totalExpanse > totalBal,
                            child: ShowBalance(
                              total: totalBal - group.totalExpanse,
                              title: 'Liabilities',
                              warn: group.totalExpanse > totalBal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Expenditure',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    ExpenditureList(expenders: expenders, group: group)
                  ],
                ),
              );
            },
          ),
          floatingActionButton: GestureDetector(
            onTap: () => showAddExpanseSheet(context, getIntend(group)),
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: AppTheme.decoration(context).copyWith(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(getIntend(group).name),
                  const SizedBox(width: 10),
                  const Icon(Icons.add_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
