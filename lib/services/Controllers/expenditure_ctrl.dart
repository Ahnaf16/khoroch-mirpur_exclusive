import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/enums.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/widgets/widgets.dart';

class ExpandState {
  ExpandState({
    required this.expend,
    required this.isAdd,
  });

  static ExpandState empty =
      ExpandState(expend: ExpenseModel.empty, isAdd: true);

  final ExpenseModel expend;
  final bool isAdd;

  ExpandState copyWith({
    ExpenseModel? expend,
    bool? isAdd,
  }) {
    return ExpandState(
      expend: expend ?? this.expend,
      isAdd: isAdd ?? this.isAdd,
    );
  }
}

final expenditureCtrl = StateNotifierProvider.family<ExpenditureNotifier,
    ExpandState, ExpenseModel?>((ref, updatingExpense) {
  return ExpenditureNotifier(updatingExpense);
});

class ExpenditureNotifier extends StateNotifier<ExpandState> {
  ExpenditureNotifier(ExpenseModel? updatingExpense)
      : super(ExpandState.empty.copyWith(expend: updatingExpense)) {
    init(updatingExpense);
  }
  final amountCtrl = TextEditingController();
  final itemCtrl = TextEditingController();

  final _fire = FirebaseFirestore.instance;
  final uid = getUser?.uid;
  init(ExpenseModel? updatingExpense) {
    if (updatingExpense != null) {
      amountCtrl.text = updatingExpense.amount.toString();
      itemCtrl.text = updatingExpense.item;
    }
  }

  addNew(BuildContext context, Intend intend) async {
    applyCtrls();

    final status = switch (intend) {
      Intend.add => ExpenseStatus.approved,
      Intend.approval => ExpenseStatus.approved,
      Intend.request => ExpenseStatus.pending,
    };

    final snap = await _fire.collection(FirePath.users).get();

    final user = snap.docs
        .map((e) => UsersModel.fromDoc(e))
        .where((element) => element.uid == uid)
        .firstOrNull;

    state = state.copyWith(
      expend: state.expend.copyWith(status: status, addedBy: user),
    );

    if (!isValid(context)) {
      return 0;
    }

    try {
      _loader(context).show('Please Wait');
      final doc =
          _coll().doc(state.expend.date.millisecondsSinceEpoch.toString());

      if (intend == Intend.approval) {
        await doc.update(state.expend.toMap());
      } else {
        await doc.set(state.expend.toMap());
      }

      context.pop;
      _loader(context).showSuccess('Expanse Added !!');
    } on FirebaseException catch (e) {
      context.pop;
      _loader(context).showError('Error : ${e.message}');
    }
    amountCtrl.clear();
    itemCtrl.clear();
  }

  bool isValid(BuildContext context) {
    if (state.expend.amount < 1) {
      _loader(context).showError('Amount can not be 0');
      return false;
    }

    if (state.expend.item.isEmpty) {
      _loader(context).showError('Spend on ?');
      return false;
    }
    if (state.expend.addedBy == null) {
      _loader(context).showError('Something went wrong !!');
      return false;
    }

    return true;
  }

  applyCtrls() {
    state = state.copyWith(
      expend: state.expend.copyWith(
        amount: amountCtrl.text.asInt,
        item: itemCtrl.text,
        date: DateTime.now(),
      ),
    );
    if (state.expend.item.isEmpty) {
      setQuickItem('Other');
    }
  }

  setQuickItem(String item) {
    itemCtrl.text = item;
  }

  toggleOperator(bool isAdd) {
    state = state.copyWith(isAdd: isAdd);
  }

  setQuickAmount(int amount) {
    final current = amountCtrl.text.asInt;
    final isAdd = state.isAdd;

    final newAmount = switch (isAdd) {
      true => current + amount,
      false when (current - amount) > 0 => current - amount,
      _ => current,
    };
    amountCtrl.text = newAmount.toString();
  }

  OverlayLoader _loader(BuildContext context) => OverlayLoader(context);

  CollectionReference _coll() => _fire.collection(FirePath.expend);
}
