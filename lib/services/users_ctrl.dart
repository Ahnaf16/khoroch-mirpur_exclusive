import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/const/firebase_const.dart';
import 'package:khoroch/models/models.dart';

final usersProvider = StreamProvider<List<UsersModel>>((ref) async* {
  final fire = FirebaseFirestore.instance;
  final snap = fire.collection(FirePath.users).snapshots();
  yield* snap
      .map((event) => event.docs.map((e) => UsersModel.fromDoc(e)).toList());
});
