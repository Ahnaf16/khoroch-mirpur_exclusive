import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/controllers/controllers.dart';

final trashProvider = StateNotifierProvider.family<TrashNotifier,
    AsyncValue<List<ExpenseModel>>, String>((ref, gid) {
  return TrashNotifier(ref, gid).._init();
});

class TrashNotifier extends StateNotifier<AsyncValue<List<ExpenseModel>>> {
  TrashNotifier(this._ref, this.gid) : super(const AsyncValue.loading());

  final String gid;
  final Ref _ref;

  final _fire = FirebaseFirestore.instance;

  _init() async {
    state = const AsyncValue.loading();

    final snap = _coll
        .where('toBeDeleted', isEqualTo: true)
        .orderBy('date', descending: true)
        .snapshots();

    final expanseStream = snap.map(
        (event) => event.docs.map((e) => ExpenseModel.fromDoc(e)).toList());

    _putData(expanseStream);
  }

  _putData(Stream<List<ExpenseModel>> expanseStream) async {
    await for (final expanse in expanseStream) {
      state = AsyncValue.data(expanse);
    }
  }

  // reload() async => await _init();

  deleteForever(String id) async {
    final doc = _coll.doc(id);
    await doc.delete();
    // await reload();
  }

  clearAll() async {
    final batch = _fire.batch();
    final data = state.value;

    if (data == null) return 0;

    for (var element in data) {
      final doc = _coll.doc(element.docId);
      batch.delete(doc);
    }

    await batch.commit();
    // await reload();
  }

  restore(BuildContext context, ExpenseModel expense) async {
    final groupCtrl = _ref.read(groupCtrlProvider.notifier);
    final doc = _coll.doc(expense.docId);
    final updated = expense.copyWith(toBeDeleted: false);
    await doc.update(updated.toMap());
    if (expense.status == ExpenseStatus.approved) {
      await groupCtrl.updateTotalExpanse(context, gid, expense.amount, true);
    }
    // await reload();
  }

  CollectionReference<Map<String, dynamic>> get _coll =>
      _fire.collection(FirePath.group).doc(gid).collection(FirePath.expense);
}
