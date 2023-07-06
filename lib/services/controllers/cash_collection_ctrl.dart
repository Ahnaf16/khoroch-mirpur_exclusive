// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/widgets/widgets.dart';
import 'package:nanoid/nanoid.dart';

final cashCollectionCtrl = StateNotifierProvider.family<CashCollectionNotifier,
    CashCollection, String>((ref, uid) => CashCollectionNotifier(uid));

class CashCollectionNotifier extends StateNotifier<CashCollection> {
  CashCollectionNotifier(this.uid) : super(CashCollection.empty);

  final _fire = FirebaseFirestore.instance;
  final String uid;

  final amountCtrl = TextEditingController();

  CollectionReference _coll() => _fire
      .collection(FirePath.users)
      .doc(uid)
      .collection(FirePath.cashCollection);

  addNewCashRecord(BuildContext context) async {
    if (amountCtrl.text.isEmpty) {
      return _loader(context).showError('Enter Cash Amount');
    }
    _loader(context).show('Adding');
    final docId = nanoid(10);
    state = state.copyWith(id: docId, amount: amountCtrl.text.asInt);
    await _coll().doc(docId).set(state.toMap());
    amountCtrl.clear();
    _loader(context).showSuccess('Success');
  }

  delete(BuildContext context, String docId) async {
    _loader(context).show('Deleting');
    await _coll().doc(docId).delete();
    context.pop;
    _loader(context).showSuccess('Delete Successfully');
  }

  OverlayLoader _loader(BuildContext context) => OverlayLoader(context);
}
