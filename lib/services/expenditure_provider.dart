import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/models/models.dart';

final expenditureProvider = StreamProvider<List<ExpendModel>>((ref) async* {
  final doc = FirebaseFirestore.instance
      .collection(FirePath.expend)
      .orderBy('date', descending: true);
  final snap = doc.snapshots();

  final expenditure = snap
      .map((event) => event.docs.map((e) => ExpendModel.fromDoc(e)).toList());

  yield* expenditure;
});
