import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/repository/repository.dart';

final userListCtrlProvider =
    StateNotifierProvider<UserListCtrlNotifier, AsyncValue<List<UsersModel>>>(
        (ref) {
  return UserListCtrlNotifier(ref);
});

class UserListCtrlNotifier extends StateNotifier<AsyncValue<List<UsersModel>>> {
  UserListCtrlNotifier(this._ref) : super(const AsyncValue.data([]));

  final Ref _ref;
  final userMailCtrl = TextEditingController();

  UserRepo get _repo => _ref.watch(userRepoProvider);

  Future<UsersModel> getCurrentUser() async {
    final res = await _repo.getCurrentUser();

    return res;
  }

  searchUser([String? query]) async {
    state = const AsyncValue.loading();
    if (query != null) userMailCtrl.text = query;
    if (userMailCtrl.text.isEmpty) return 0;

    final res = await _repo.searchUser(userMailCtrl.text.trim().toLowerCase());

    res.fold((l) => null, (r) => _putData(r));
  }

  createUserDoc(context, User user) async {
    await _repo.createUserDoc(user);
    log('user Created');
  }

  _putData(Stream<List<UsersModel>> userStream) async {
    await for (final user in userStream) {
      log(user.length.toString());
      state = AsyncValue.data(user);
    }
  }
}
