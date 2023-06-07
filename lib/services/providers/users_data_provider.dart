import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/services.dart';

final userListProvider = StreamProvider<List<UsersModel>>((ref) async* {
  final fire = FirebaseFirestore.instance;
  final snap = fire.collection(FirePath.users).snapshots();
  final users = snap
      .map((event) => event.docs.map((e) => UsersModel.fromDoc(e)).toList());

  yield* users;
});

final currentUserProvider =
    StreamProvider.autoDispose<UsersModel?>((ref) async* {
  final fire = FirebaseFirestore.instance;
  final uid = getUser?.uid;
  final snap = fire.collection(FirePath.users).doc(uid).snapshots();

  final user = snap.map((event) => UsersModel.fromDoc(event));

  yield* user;
});

final userProvider =
    StreamProvider.family.autoDispose<UsersModel, String>((ref, uid) async* {
  final fire = FirebaseFirestore.instance;
  final snap = fire.collection(FirePath.users).doc(uid).snapshots();

  final user = snap.map((event) => UsersModel.fromDoc(event));

  yield* user;
});
