// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/controllers/group_ctrl.dart';
import 'package:khoroch/services/providers/providers.dart';
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
  return ExpenditureNotifier(ref, updatingExpense);
});

class ExpenditureNotifier extends StateNotifier<ExpandState> {
  ExpenditureNotifier(this._ref, this.updatingExpense)
      : super(ExpandState.empty.copyWith(expend: updatingExpense)) {
    init();
  }
  final Ref _ref;
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

  addNew(BuildContext context, Intend intend, String groupId) async {
    applyCtrls();

    final status = switch (intend) {
      Intend.add => ExpenseStatus.approved,
      Intend.approval => ExpenseStatus.approved,
      Intend.request => ExpenseStatus.pending,
    };
    final groupCtrl = _ref.read(groupCtrlProvider.notifier);
    final userSnap = await _fire.collection(FirePath.users).doc(uid).get();

    final user = updatingExpense == null
        ? UsersModel.fromDoc(userSnap)
        : updatingExpense!.addedBy;

    state = state.copyWith(
      expend: state.expend.copyWith(status: status, addedBy: user),
    );

    if (!isValid(context)) return 0;

    final docId = updatingExpense == null ? nanoid(10) : updatingExpense!.docId;

    state = state.copyWith(expend: state.expend.copyWith(docId: docId));

    try {
      context.showOverLay.show('Please Wait');

      final doc = _coll(groupId).doc(docId);

      if (intend == Intend.approval) {
        state = state.copyWith(
            expend: state.expend.copyWith(date: updatingExpense!.date));
        await doc.update(state.expend.toMap());
      } else {
        await doc.set(state.expend.toMap());
      }
      if (intend != Intend.request) {
        await groupCtrl.updateTotalExpanse(
          context,
          groupId,
          amountCtrl.text.asInt,
          true,
        );
      }

      context.pop;
      context.showOverLay.showSuccess('Expanse Added !!');
      amountCtrl.clear();
      itemCtrl.clear();
    } on FirebaseException catch (e) {
      context.pop;
      context.showOverLay.showError('Error : ${e.message}');
    }
  }

  rejected(BuildContext context, String id) async {
    state = state.copyWith(
      expend: state.expend.copyWith(status: ExpenseStatus.rejected),
    );
    final doc = _coll(id).doc(state.expend.docId);

    await doc.update(state.expend.toMap());
    context.showOverLay.showSuccess('Expanse rejected');
    context.pop;
  }

  moveToTrash(BuildContext context, String gid) async {
    final groupCtrl = _ref.read(groupCtrlProvider.notifier);

    if (updatingExpense == null) {
      context.showOverLay.showError('Unable to delete');
      return 0;
    } else {
      final doc = _coll(gid).doc(updatingExpense!.docId);
      final data = state.expend.copyWith(toBeDeleted: true).toMap();
      await doc.update(data);
      if (state.expend.status == ExpenseStatus.approved) {
        groupCtrl.updateTotalExpanse(context, gid, state.expend.amount, false);
      }
    }
  }

  bool isValid(BuildContext context) {
    if (state.expend.amount < 1) {
      context.showOverLay.showError('Amount can not be 0');
      return false;
    }

    if (state.expend.item.isEmpty) {
      context.showOverLay.showError('Spend on ?');
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

  CollectionReference _coll(String id) =>
      _fire.collection(FirePath.group).doc(id).collection(FirePath.expense);
}
