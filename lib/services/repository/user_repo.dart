import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/models/models.dart';

final userRepoProvider = Provider<UserRepo>((ref) {
  return UserRepo();
});

class UserRepo {
  final _fire = FirebaseFirestore.instance;

  createUserDoc(User fireUser) async {
    try {
      final user = UsersModel(
        collectedCash: [],
        name: fireUser.displayName ?? '',
        photo: fireUser.photoURL ?? '',
        uid: fireUser.uid,
        email: fireUser.email ?? '',
        role: Role.viewer,
      );
      final doc = _fire.collection(FirePath.users).doc(user.uid);
      final e = await doc.get();
      if (!e.exists) {
        await doc.set(user.toMap());
      }
    } on FirebaseException catch (exc) {
      log(exc.message ?? 'Something went wrong');
    }
  }
}
