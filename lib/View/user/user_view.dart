import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/services/providers/groups_provider.dart';
import 'package:khoroch/services/providers/providers.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserDetails extends ConsumerWidget {
  const UserDetails({required this.groupId, required this.uid, super.key});

  final String uid;
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final argument = (uid: uid, gid: groupId);
    final groupData = ref.watch(groupByIdProvider(groupId));
    final cashCollections = ref.watch(cashCollectionsProvider(argument));
    final cashCtrl = ref.read(cashCollectionCtrl(argument).notifier);

    return groupData.when(
      error: ErrorView.errorMathod,
      loading: () => const Loader(isList: false),
      data: (group) {
        return cashCollections.when(
          error: ErrorView.errorMathod,
          loading: () => const Loader(isList: true),
          data: (cash) {
            final user =
                group.users.where((element) => element.uid == uid).first;
            final total = cash.map((e) => e.amount).sum;
            final canAdd = getUser!.uid == group.ownerId;
            return SafeArea(
              child: Scaffold(
                appBar: KAppBar(
                  title: user.name,
                  leading: IconButton(
                    onPressed: () => context.rPop,
                    icon: const Icon(Icons.close),
                  ),
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
                              decoration: AppTheme.decoration(context).copyWith(
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
                                            context,
                                            collected.id,
                                            user.uid,
                                            collected.amount,
                                          ),
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
                floatingActionButton: !canAdd
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
                          decoration: AppTheme.decoration(context).copyWith(
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
      backgroundColor: AppTheme.mainColor,
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
      decoration: AppTheme.decoration(context),
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
        borderRadius: AppTheme.decoration(context).borderRadius!,
      ),
      actions: [
        NeuButton(
          width: 50,
          onTap: () => context.pop,
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
      backgroundColor: AppTheme.mainColor,
      content: Container(
        decoration: AppTheme.decoration(context),
        child: ClipRRect(
          borderRadius: AppTheme.decoration(context).borderRadius,
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
