import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/models/models.dart';

final cashCollectionsProvider = StreamProvider.family
    .autoDispose<List<CashCollection>, ({String uid, String gid})>(
        (ref, ids) async* {
  var fire = FirebaseFirestore.instance;
  final snap = fire
      .collection(FirePath.group)
      .doc(ids.gid)
      .collection(FirePath.cashCollection)
      .where('user.uid', isEqualTo: ids.uid)
      .orderBy('date', descending: true)
      .snapshots();

  final collections = snap.map(
      (event) => event.docs.map((e) => CashCollection.fromDoc(e)).toList());

  yield* collections;
});

final totalCashCollectedProvider = StreamProvider<int>((ref) async* {
  final snap = FirebaseFirestore.instance
      .collectionGroup(FirePath.cashCollection)
      .snapshots();

  final total = snap.map((event) => event.docs
      .map((e) => CashCollection.fromDoc(e))
      .toList()
      .map((e) => e.amount)
      .sum);

  yield* total;
});
