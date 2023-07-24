import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:khoroch/core/const/quick_items.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/models.dart';

import '../../../theme/theme.dart';

class AddExpanseSheet extends ConsumerWidget {
  const AddExpanseSheet({
    super.key,
    required this.intend,
    required this.groupId,
    this.updatingExpense,
  });

  final Intend intend;
  final ExpenseModel? updatingExpense;
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseCtrl = ref.read(expenditureCtrl(updatingExpense).notifier);
    final expense = ref.watch(expenditureCtrl(updatingExpense));
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  decoration: AppTheme.decoration(context),
                  child: ClipRRect(
                    borderRadius: AppTheme.decoration(context).borderRadius,
                    child: TextField(
                      controller: expenseCtrl.amountCtrl,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      cursorColor: AppTheme.foregroundColor,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixIcon: Icon(MdiIcons.currencyBdt),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => expenseCtrl.toggleOperator(true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 48,
                  width: 48,
                  decoration: AppTheme.decoration(context).copyWith(
                    borderRadius: BorderRadius.circular(10),
                    color: expense.isAdd
                        ? AppTheme.foregroundColor.withOpacity(.5)
                        : null,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: expense.isAdd ? AppTheme.mainColor : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => expenseCtrl.toggleOperator(false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 48,
                  width: 48,
                  decoration: AppTheme.decoration(context).copyWith(
                    borderRadius: BorderRadius.circular(10),
                    color: !expense.isAdd
                        ? AppTheme.foregroundColor.withOpacity(.5)
                        : null,
                  ),
                  child: Icon(
                    Icons.remove_rounded,
                    color: !expense.isAdd ? AppTheme.mainColor : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            clipBehavior: Clip.none,
            spacing: 15,
            runSpacing: 15,
            children: [
              ...QuickItems.amount.map(
                (e) => GestureDetector(
                  onTap: () {
                    expenseCtrl.setQuickAmount(e);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: AppTheme.decoration(context).copyWith(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text((expense.isAdd ? '+ ' : '- ') + e.toCurrency),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            decoration: AppTheme.decoration(context),
            child: ClipRRect(
              borderRadius: AppTheme.decoration(context).borderRadius,
              child: TextField(
                controller: expenseCtrl.itemCtrl,
                cursorColor: Colors.grey.shade500,
                decoration: const InputDecoration(
                  labelText: 'Spend on',
                  prefixIcon: Icon(MdiIcons.package),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            clipBehavior: Clip.none,
            spacing: 15,
            runSpacing: 15,
            children: [
              ...QuickItems.items.map(
                (e) => GestureDetector(
                  onTap: () {
                    expenseCtrl.setQuickItem(e);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: AppTheme.decoration(context).copyWith(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(e),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (intend == Intend.approval)
                NeuButton(
                  onTap: () => expenseCtrl.rejected(context, groupId),
                  width: context.width / 2.5,
                  child: const Icon(Icons.close),
                ),
              if (intend == Intend.approval) const SizedBox(width: 20),
              NeuButton(
                onTap: () => expenseCtrl.addNew(context, intend, groupId),
                height: 50,
                width: context.width / 2.5,
                child: Text(intend.name),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
