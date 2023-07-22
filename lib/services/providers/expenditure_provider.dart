import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/models/models.dart';

final expenditureProvider =
    StreamProvider.family<List<ExpenseModel>, String>((ref, id) async* {
  final doc = FirebaseFirestore.instance
      .collection(FirePath.group)
      .doc(id)
      .collection(FirePath.expense)
      .where('toBeDeleted', isEqualTo: false)
      .orderBy('date', descending: true);
  final snap = doc.snapshots();

  final expenditure = snap
      .map((event) => event.docs.map((e) => ExpenseModel.fromDoc(e)).toList());

  yield* expenditure;
});
