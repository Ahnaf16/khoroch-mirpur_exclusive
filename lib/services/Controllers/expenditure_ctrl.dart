// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/enums.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/widgets/widgets.dart';
import 'package:nanoid/nanoid.dart';

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
  ExpenditureNotifier(this.updatingExpense)
      : super(ExpandState.empty.copyWith(expend: updatingExpense)) {
    init();
  }
  final amountCtrl = TextEditingController();
  final itemCtrl = TextEditingController();

  final _fire = FirebaseFirestore.instance;
  final uid = getUser?.uid;
  final ExpenseModel? updatingExpense;

  init() {
    if (updatingExpense != null) {
      amountCtrl.text = updatingExpense!.amount.toString();
      itemCtrl.text = updatingExpense!.item;
    }
  }

  addNew(BuildContext context, Intend intend) async {
    applyCtrls();

    final status = switch (intend) {
      Intend.add => ExpenseStatus.approved,
      Intend.approval => ExpenseStatus.approved,
      Intend.request => ExpenseStatus.pending,
    };

    final snap = await _fire.collection(FirePath.users).doc(uid).get();

    final user = updatingExpense == null
        ? UsersModel.fromDoc(snap)
        : updatingExpense!.addedBy;

    state = state.copyWith(
      expend: state.expend.copyWith(status: status, addedBy: user),
    );

    if (!isValid(context)) {
      return 0;
    }
    final docId = updatingExpense == null ? nanoid(10) : updatingExpense!.docId;

    state = state.copyWith(expend: state.expend.copyWith(docId: docId));

    try {
      _loader(context).show('Please Wait');

      final doc = _coll().doc(docId);

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

  rejected() async {
    state = state.copyWith(
      expend: state.expend.copyWith(status: ExpenseStatus.rejected),
    );
    final doc =
        _coll().doc(state.expend.date.millisecondsSinceEpoch.toString());

    await doc.update(state.expend.toMap());
  }

  moveToTrash(BuildContext context) async {
    if (updatingExpense == null) {
      _loader(context).showError('Unable to delete');
      return 0;
    } else {
      final doc = _coll().doc(updatingExpense!.docId);
      final data = state.expend.copyWith(toBeDeleted: true).toMap();
      await doc.update(data);
    }
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
