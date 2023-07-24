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
              IconButton(
                onPressed: () => context.pushTo(RouteName.trash(group.id),
                    quarry: {'owner': group.ownerId}),
                icon: const Icon(Icons.delete_rounded),
              )
            ],
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(20).copyWith(top: 0),
                      decoration: AppTheme.decoration(context),
                      alignment: Alignment.center,
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          ...group.users.map(
                            (user) => GestureDetector(
                              onTap: () => context.pushTo(
                                  RouteName.userFromGroup(groupId, user.uid)),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(15),
                                    decoration:
                                        AppTheme.decoration(context).copyWith(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: getUser?.uid == user.uid
                                          ? [
                                              BoxShadow(
                                                blurRadius: 15,
                                                color:
                                                    Colors.blue.withOpacity(.2),
                                                offset: const Offset(4, 4),
                                              ),
                                              BoxShadow(
                                                blurRadius: 15,
                                                color:
                                                    Colors.blue.withOpacity(.2),
                                                offset: const Offset(-4, -4),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Column(
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
                                                image:
                                                    KCachedImg(url: user.photo)
                                                        .provider,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              user.name.split(' ').first,
                                              style:
                                                  context.textTheme.bodyLarge,
                                            ),
                                            if (group.ownerId == user.uid)
                                              const Icon(
                                                Icons.verified_outlined,
                                                size: 18,
                                              ),
                                          ],
                                        ),
                                        Text(
                                          group
                                              .cashAmount[user.uid]!.toCurrency,
                                          style: context.textTheme.titleLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Expenditure',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
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
