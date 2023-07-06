import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/users_model.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class UserDetails extends ConsumerWidget {
  const UserDetails({required this.uid, super.key});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider(uid));
    final currentUserData = ref.watch(currentUserProvider);
    final cashCollections = ref.watch(cashCollectionsProvider(uid));
    final cashCtrl = ref.read(cashCollectionCtrl(uid).notifier);

    var user = currentUserData.value;

    final canAdd = switch (user) {
      null => false,
      _ when user.canAdd => true,
      _ => false,
    };

    return userData.when(
      error: ErrorView.errorMathod,
      loading: () => const Loader(isList: false),
      data: (user) {
        return cashCollections.when(
          error: ErrorView.errorMathod,
          loading: () => const Loader(isList: true),
          data: (cash) {
            final total = cash.map((e) => e.amount).sum;
            return SafeArea(
              child: Scaffold(
                appBar: KAppBar(
                  title: user.name,
                  actions: [
                    IconButton.filled(
                      onPressed: () => context.rPop,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: user.uid,
                            child: Container(
                              height: 100,
                              width: 100,
                              clipBehavior: Clip.none,
                              decoration: AppTheme.neuDecoration.copyWith(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(100),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: KCachedImg(url: user.photo).provider,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name,
                                  style: context.textTheme.titleLarge),
                              const SizedBox(height: 10),
                              Text(user.email),
                              const SizedBox(height: 10),
                              Text('Total collected : $total'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Cash Collections',
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: cash.length,
                          itemBuilder: (context, index) {
                            final collected = cash[index];
                            return Slidable(
                              enabled: canAdd,
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => CashDeleteDialog(
                                          onDelete: () => cashCtrl.delete(
                                              context, collected.id),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    backgroundColor: Colors.red.withOpacity(.1),
                                    foregroundColor: Colors.red,
                                    icon: Icons.delete_forever,
                                    label: 'Delete',
                                    autoClose: true,
                                  ),
                                ],
                              ),
                              child: UserCashTile(collected: collected),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: currentUserData.maybeWhen(
                  orElse: () => null,
                  data: (user) => !user!.canAdd
                      ? null
                      : GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AddCashAmountDialog(cashCtrl: cashCtrl);
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: AppTheme.neuDecoration.copyWith(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('A d d'),
                                SizedBox(width: 10),
                                Icon(Icons.add_rounded),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CashDeleteDialog extends StatelessWidget {
  const CashDeleteDialog({
    super.key,
    required this.onDelete,
  });

  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 50,
      backgroundColor: AppTheme.backgroundColor,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding:
          const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
      actions: [
        NeuButton(
          onTap: () => context.pop,
          width: 50,
          child: const Icon(Icons.close_rounded),
        ),
        NeuButton(
          width: 150,
          onTap: onDelete,
          child: const Text('Delete'),
        ),
      ],
      title: const Text('Sure ??'),
      content: const Text(
        'Are you sure? \nThis Can\'t be undone',
      ),
    );
  }
}

class UserCashTile extends StatelessWidget {
  const UserCashTile({
    super.key,
    required this.collected,
  });

  final CashCollection collected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: AppTheme.neuDecoration,
      child: Row(
        children: [
          const Icon(MdiIcons.currencyBdt),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                collected.amount.toCurrency,
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          const Spacer(),
          Text(
            collected.date.formateDate(),
            style: context.textTheme.labelLarge,
            textAlign: TextAlign.end,
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class AddCashAmountDialog extends ConsumerWidget {
  const AddCashAmountDialog({
    super.key,
    required this.cashCtrl,
  });

  final CashCollectionNotifier cashCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.neuDecoration.borderRadius!,
      ),
      actions: [
        NeuButton(
          width: 50,
          onTap: () {},
          child: const Icon(Icons.close_rounded),
        ),
        NeuButton(
          width: 200,
          onTap: () {
            cashCtrl.addNewCashRecord(context);
          },
          child: const Text('ADD'),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      backgroundColor: AppTheme.backgroundColor,
      content: Container(
        decoration: AppTheme.neuDecoration,
        child: ClipRRect(
          borderRadius: AppTheme.neuDecoration.borderRadius,
          child: TextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            controller: cashCtrl.amountCtrl,
            cursorColor: Colors.grey.shade500,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixIcon: Icon(MdiIcons.currencyBdt),
            ),
          ),
        ),
      ),
    );
  }
}
