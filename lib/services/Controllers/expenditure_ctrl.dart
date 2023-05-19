import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/widgets/widgets.dart';

class ExpandState {
  ExpandState({
    required this.expend,
    required this.isAdd,
  });

  final ExpendModel expend;
  final bool isAdd;

  ExpandState copyWith({
    ExpendModel? expend,
    bool? isAdd,
  }) {
    return ExpandState(
      expend: expend ?? this.expend,
      isAdd: isAdd ?? this.isAdd,
    );
  }

  static ExpandState empty =
      ExpandState(expend: ExpendModel.empty, isAdd: true);
}

final expenditureCtrl =
    StateNotifierProvider<ExpenditureNotifier, ExpandState>((ref) {
  return ExpenditureNotifier();
});

class ExpenditureNotifier extends StateNotifier<ExpandState> {
  ExpenditureNotifier() : super(ExpandState.empty);

  final amountCtrl = TextEditingController();
  final itemCtrl = TextEditingController();

  final _fire = FirebaseFirestore.instance;

  OverlayLoader _loader(BuildContext context) => OverlayLoader(context);

  addNew(BuildContext context) async {
    applyCtrls();
    if (!isValid(context)) {
      return 0;
    }

    try {
      _loader(context).show('Please Wait');
      final doc =
          _coll().doc(state.expend.date.millisecondsSinceEpoch.toString());

      await doc.set(state.expend.toMap());

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
      _loader(context).showError('Enter Amount');
      return false;
    }

    return true;
  }

  applyCtrls() {
    if (state.expend.item.isEmpty) {
      setQuickItem('Other');
    }
    state = state.copyWith(
      expend: state.expend.copyWith(
        amount: amountCtrl.text.asInt,
        item: itemCtrl.text,
        date: DateTime.now(),
      ),
    );
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

  CollectionReference _coll() => _fire.collection(FirePath.expend);
}
