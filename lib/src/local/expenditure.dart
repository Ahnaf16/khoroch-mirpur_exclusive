import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/const/quick_items.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/services/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../theme/theme.dart';

class AddExpanseSheet extends ConsumerWidget {
  const AddExpanseSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expendCtrl = ref.read(expenditureCtrl.notifier);
    final expend = ref.watch(expenditureCtrl);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  decoration: AppTheme.neuDecoration,
                  child: ClipRRect(
                    borderRadius: AppTheme.neuDecoration.borderRadius,
                    child: TextField(
                      controller: expendCtrl.amountCtrl,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.grey.shade500,
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
                onTap: () => expendCtrl.toggleOperator(true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 48,
                  width: 48,
                  decoration: AppTheme.neuDecoration.copyWith(
                    borderRadius: BorderRadius.circular(10),
                    color: expend.isAdd ? AppTheme.defContentColor : null,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: expend.isAdd ? AppTheme.backgroundColor : null,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => expendCtrl.toggleOperator(false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 48,
                  width: 48,
                  decoration: AppTheme.neuDecoration.copyWith(
                    borderRadius: BorderRadius.circular(10),
                    color: !expend.isAdd ? AppTheme.defContentColor : null,
                  ),
                  child: Icon(
                    Icons.remove_rounded,
                    color: !expend.isAdd ? AppTheme.backgroundColor : null,
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
                    expendCtrl.setQuickAmount(e);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: AppTheme.neuDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text((expend.isAdd ? '+ ' : '- ') + e.toCurrency),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            decoration: AppTheme.neuDecoration,
            child: ClipRRect(
              borderRadius: AppTheme.neuDecoration.borderRadius,
              child: TextField(
                controller: expendCtrl.itemCtrl,
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
                    expendCtrl.setQuickItem(e);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: AppTheme.neuDecoration.copyWith(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(e),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => expendCtrl.addNew(context),
            child: Container(
              height: 50,
              width: double.maxFinite,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              decoration: AppTheme.neuDecoration.copyWith(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('A D D'),
            ),
          ),
        ],
      ),
    );
  }
}
