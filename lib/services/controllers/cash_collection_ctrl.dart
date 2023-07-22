// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/controllers/group_ctrl.dart';
import 'package:nanoid/nanoid.dart';

final cashCollectionCtrl = StateNotifierProvider.family<
    CashCollectionNotifier,
    CashCollection,
    ({String uid, String gid})>((ref, ids) => CashCollectionNotifier(ref, ids));

class CashCollectionNotifier extends StateNotifier<CashCollection> {
  CashCollectionNotifier(this._ref, this.ids) : super(CashCollection.empty);
  final Ref _ref;
  final _fire = FirebaseFirestore.instance;
  final ({String uid, String gid}) ids;

  final amountCtrl = TextEditingController();

  CollectionReference _coll() => _fire
      .collection(FirePath.group)
      .doc(ids.gid)
      .collection(FirePath.cashCollection);

  addNewCashRecord(BuildContext context) async {
    if (amountCtrl.text.isEmpty) {
      return context.showOverLay.showError('Enter Cash Amount');
    }
    context.showOverLay.show('Adding');
    final groupCtrl = _ref.read(groupCtrlProvider.notifier);

    final userSnap = await _fire.collection(FirePath.users).doc(ids.uid).get();
    final user = UsersModel.fromDoc(userSnap);

    final docId = nanoid(10);
    state = state.copyWith(
      id: docId,
      amount: amountCtrl.text.asInt,
      user: user,
    );
    await _coll().doc(docId).set(state.toMap());
    groupCtrl.updateUserCash(
        context, ids.gid, user.uid, amountCtrl.text.asInt, true);
    amountCtrl.clear();
    context.showOverLay.showSuccess('Success');
  }

  delete(BuildContext context, String docId, String uid, int amount) async {
    final groupCtrl = _ref.read(groupCtrlProvider.notifier);
    context.showOverLay.show('Deleting');
    await _coll().doc(docId).delete();
    await groupCtrl.updateUserCash(context, ids.gid, uid, amount, false);
    context.pop;
    context.showOverLay.showSuccess('Delete Successfully');
  }
}
