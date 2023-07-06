import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/widgets/expand_tile.dart';
import 'package:khoroch/widgets/widgets.dart';

class ExpenditureList extends ConsumerWidget {
  const ExpenditureList({
    super.key,
    required this.expenders,
  });
  final List<ExpenseModel> expenders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(currentUserProvider);

    return userData.when(
      error: (error, stackTrace) => const Center(child: Text('E R R O R')),
      loading: () => const Loader(isList: true),
      data: (user) {
        final canAdd = switch (user) {
          null => false,
          _ when user.canAdd => true,
          _ => false,
        };

        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: expenders.length,
          itemBuilder: (BuildContext context, int index) {
            final expense = expenders[index];
            final expenseCtrl = ref.read(expenditureCtrl(expense).notifier);
            return Slidable(
              enabled: canAdd,
              endActionPane: ActionPane(
                extentRatio: 0.2,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      expenseCtrl.moveToTrash(context);
                    },
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.red.withOpacity(.1),
                    foregroundColor: Colors.red,
                    icon: Icons.delete,
                    label: 'Delete',
                    autoClose: true,
                  ),
                ],
              ),
              child: ExpandTile(expense: expense, canAdd: canAdd),
            );
          },
        );
      },
    );
  }
}
