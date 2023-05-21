import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/services/services.dart';

final userCtrlProvider = StateNotifierProvider<UserCtrlNotifier, bool>((ref) {
  return UserCtrlNotifier(ref);
});

class UserCtrlNotifier extends StateNotifier<bool> {
  UserCtrlNotifier(this._ref) : super(false);

  final Ref _ref;

  UserRepo get _repo => _ref.watch(userRepoProvider);

  createUserDoc(context, User user) async {
    await _repo.createUserDoc(user);
    log('user Created');
  }
}
