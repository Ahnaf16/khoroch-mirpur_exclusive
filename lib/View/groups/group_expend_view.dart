import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/View/groups/local/expense_sheet.dart';
import 'package:khoroch/View/groups/local/expenditure_list.dart';
import 'package:khoroch/View/groups/local/show_balance.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/routes/route_config.dart';
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
          endDrawer: NeuContainer(
            decoration: AppTheme.decoration(context).copyWith(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
                right: Radius.circular(0),
              ),
            ),
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: context.width / 1.5,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                NeuListTile(
                  onTap: () {
                    context.pushTo(
                      RouteName.trash(group.id),
                      quarry: {'owner': group.ownerId},
                    );
                  },
                  leading: const Icon(
                    Icons.person_add_alt_1_rounded,
                  ),
                  title: const Text('Add User'),
                ),
                NeuListTile(
                  onTap: () {
                    context.pushTo(
                      RouteName.trash(group.id),
                      quarry: {'owner': group.ownerId},
                    );
                  },
                  leading: const Icon(
                    Icons.delete_forever_rounded,
                  ),
                  title: const Text('Trash'),
                ),
                const Divider(height: 50),
                Center(
                  child: Text(
                    'Members',
                    style: context.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 10),
                ...group.users.map(
                  (user) => GestureDetector(
                    onTap: () => context
                        .pushTo(RouteName.userFromGroup(groupId, user.uid)),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            NeuContainer(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(15),
                              decoration: AppTheme.decoration(context).copyWith(
                                boxShadow: getUser?.uid == user.uid
                                    ? [
                                        BoxShadow(
                                          blurRadius: 15,
                                          color: context.isDark
                                              ? Colors.blue.shade100
                                              : Colors.blue.shade200,
                                          offset: const Offset(0, 0),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Hero(
                                    tag: user.uid,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: KCachedImg(url: user.photo)
                                              .provider,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        style: context.textTheme.bodyLarge,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        group.cashAmount[user.uid]!.toCurrency,
                                        style: context.textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (group.ownerId == user.uid)
                              Positioned(
                                top: 14,
                                left: 14,
                                child: Icon(
                                  Icons.verified_outlined,
                                  size: 18,
                                  color: AppTheme.successColor,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
