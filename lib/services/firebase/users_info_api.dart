import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/models/users_model.dart';

final usersProvider =
    StreamProvider.autoDispose<List<UsersModel>>((ref) async* {
  final fire = FirebaseFirestore.instance;
  final snap = fire.collection('users').snapshots();
  yield* snap
      .map((event) => event.docs.map((e) => UsersModel.fromDoc(e)).toList());
});
