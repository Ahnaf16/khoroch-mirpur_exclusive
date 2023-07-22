import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/services/providers/providers.dart';
import 'package:khoroch/widgets/widgets.dart';

class ExpenditureList extends ConsumerWidget {
  const ExpenditureList({
    super.key,
    required this.expenders,
    required this.group,
  });
  final List<ExpenseModel> expenders;
  final GroupModel group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: expenders.length,
      itemBuilder: (BuildContext context, int index) {
        final expense = expenders[index];
        final canAdd = group.ownerId == getUser!.uid;

        final expanseCtrl = ref.read(expenditureCtrl(expense).notifier);
        return Slidable(
          enabled: canAdd,
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  expanseCtrl.moveToTrash(context, group.id);
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
          child: ExpandTile(
            expense: expense,
            canAdd: canAdd,
            gid: group.id,
          ),
        );
      },
    );
  }
}
