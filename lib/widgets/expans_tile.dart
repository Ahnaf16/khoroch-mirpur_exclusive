import 'package:flutter/material.dart';
import 'package:khoroch/View/groups/local/expense_sheet.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExpandTile extends StatelessWidget {
  const ExpandTile({
    super.key,
    required this.expense,
    required this.canAdd,
    required this.gid,
  });

  final ExpenseModel expense;
  final bool canAdd;
  final String gid;
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
                expense.amount.toCurrency,
                style: context.textTheme.titleLarge,
              ),
              Text(
                expense.item,
                style: context.textTheme.labelLarge,
              ),
            ],
          ),
          const Spacer(),
          Text(
            expense.date.formateDate(),
            style: context.textTheme.labelLarge,
            textAlign: TextAlign.end,
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Container(
                clipBehavior: Clip.none,
                decoration: AppTheme.decoration(context).copyWith(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: KCachedImg(
                      url: expense.addedBy.photo,
                    ).provider,
                  ),
                ),
                height: 20,
                width: 20,
              ),
              if (expense.status != ExpenseStatus.approved)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: InkWell(
                    onTap: canAdd
                        ? () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => AddExpanseSheet(
                                intend: Intend.approval,
                                updatingExpense: expense,
                                groupId: gid,
                              ),
                            );
                          }
                        : null,
                    child: Icon(expense.status.icon),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
