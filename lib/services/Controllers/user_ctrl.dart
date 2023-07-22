import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/repository/repository.dart';

final userCtrlProvider =
    StateNotifierProvider<UserCtrlNotifier, AsyncValue<List<UsersModel>>>(
        (ref) {
  return UserCtrlNotifier(ref);
});

class UserCtrlNotifier extends StateNotifier<AsyncValue<List<UsersModel>>> {
  UserCtrlNotifier(this._ref) : super(const AsyncValue.data([]));

  final Ref _ref;
  final userMailCtrl = TextEditingController();

  UserRepo get _repo => _ref.watch(userRepoProvider);

  Future<UsersModel> getCurrentUser() async {
    final res = await _repo.getCurrentUser();

    return res;
  }

  searchUser() async {
    state = const AsyncValue.loading();
    if (userMailCtrl.text.isEmpty) return 0;

    final res = await _repo.searchUser(userMailCtrl.text);

    res.fold((l) => null, (r) => _putData(r));
  }

  createUserDoc(context, User user) async {
    await _repo.createUserDoc(user);
    log('user Created');
  }

  _putData(Stream<List<UsersModel>> orderStream) async {
    await for (final orders in orderStream) {
      state = AsyncValue.data(orders);
    }
  }
}
