import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/Home/local/expense_sheet.dart';
import 'package:khoroch/models/enums.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/theme/theme.dart';

class ExpenditureList extends ConsumerWidget {
  const ExpenditureList({
    super.key,
    required this.expenders,
  });
  final List<ExpenseModel> expenders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider);

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
              return Container(
                padding: const EdgeInsets.all(10),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: AppTheme.neuDecoration,
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
                    if (expense.status != ExpenseStatus.approved)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          onPressed: !canAdd
                              ? null
                              : () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => AddExpanseSheet(
                                      intend: Intend.approval,
                                      updatingExpense: expense,
                                    ),
                                  );
                                },
                          icon: Icon(expense.status.icon),
                        ),
                      ),
                    const SizedBox(width: 10),
                    Container(
                      clipBehavior: Clip.none,
                      decoration: AppTheme.neuDecoration.copyWith(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: KCachedImg(
                            url: expense.addedBy!.photo,
                          ).provider,
                        ),
                      ),
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
