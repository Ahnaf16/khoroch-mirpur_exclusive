import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/providers/providers.dart';

final userRepoProvider = Provider<UserRepo>((ref) {
  return UserRepo();
});

class UserRepo {
  final _fire = FirebaseFirestore.instance;

  FutureEither<Stream<List<UsersModel>>> searchUser(String query) async {
    query = query.replaceAll(' ', '_').toLowerCase();
    final field = query.isEmail ? 'email' : 'userName';

    final snap = _coll()
        .where(field, isEqualTo: query)
        .where('email', isNotEqualTo: getUser!.email)
        .snapshots();

    final res = snap.map((snapshot) =>
        snapshot.docs.map((doc) => UsersModel.fromDoc(doc)).toList());

    return right(res);
  }

  Future<UsersModel> getCurrentUser() async {
    final uid = getUser?.uid;
    final doc = await _fire.collection(FirePath.users).doc(uid).get();

    final user = UsersModel.fromDoc(doc);
    return user;
  }

  createUserDoc(User fireUser) async {
    try {
      final user = UsersModel(
        name: fireUser.displayName ?? '',
        photo: fireUser.photoURL ?? '',
        uid: fireUser.uid,
        email: fireUser.email!,
        userName: fireUser.displayName?.replaceAll(' ', '_').toLowerCase() ??
            fireUser.email!,
      );
      final doc = _coll().doc(user.uid);
      final e = await doc.get();
      if (!e.exists) {
        await doc.set(user.toMap());
      }
    } on FirebaseException catch (exc) {
      log(exc.message ?? 'Something went wrong');
    }
  }

  FutureEither<String> updateUser(UsersModel user) async {
    try {
      final docRef = _coll().doc(user.uid);

      await docRef.update(user.toMap());
      return right('User updated');
    } on FirebaseException catch (exc) {
      return left(Failure.fromFire(exc));
    }
  }

  CollectionReference _coll() => _fire.collection(FirePath.users);
}
