import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/models/models.dart';

final groupRepoProvider = Provider<GroupRepo>((ref) => GroupRepo());

class GroupRepo {
  final _fire = FirebaseFirestore.instance;
  CollectionReference get _coll => _fire.collection(FirePath.group);

  FutureEither<String> createGroup(GroupModel model) async {
    try {
      final doc = _coll.doc(model.id);

      await doc.set(model.toMap());
      return right('Group Created');
    } on FirebaseException catch (e) {
      log(e.message ?? 'n');
      return left(Failure(e.message ?? 'n'));
    }
  }

  Future<GroupModel> getGroup(String id) async {
    final snap = await _coll.doc(id).get();
    final model = GroupModel.fromDoc(snap);
    return model;
  }

  FutureEither<String> updateGroup(GroupModel model) async {
    try {
      final doc = _coll.doc(model.id);

      await doc.update(model.toMap());
      return right('Group Updated');
    } on FirebaseException catch (e) {
      log(e.message ?? 'n');
      return left(Failure(e.message ?? 'n'));
    }
  }
}
