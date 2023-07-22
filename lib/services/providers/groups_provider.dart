import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/providers/providers.dart';

final groupProvider =
    StreamProvider.autoDispose<List<GroupModel>>((ref) async* {
  final fire = FirebaseFirestore.instance;
  final snap = fire
      .collection(FirePath.group)
      .where('usersId', arrayContains: getUser!.uid)
      .snapshots();
  yield* snap
      .map((event) => event.docs.map((e) => GroupModel.fromDoc(e)).toList());
});

final groupByIdProvider =
    StreamProvider.autoDispose.family<GroupModel, String>((ref, id) async* {
  final fire = FirebaseFirestore.instance;
  final snap = fire.collection(FirePath.group).doc(id).snapshots();
  yield* snap.map((e) => GroupModel.fromDoc(e));
});
