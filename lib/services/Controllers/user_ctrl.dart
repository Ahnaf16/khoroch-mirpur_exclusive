import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/repository/repository.dart';

final userCtrlProvider =
    StateNotifierProvider<UserCtrlNotifier, (UsersModel, bool)>((ref) {
  return UserCtrlNotifier(ref).._init();
});

class UserCtrlNotifier extends StateNotifier<(UsersModel, bool)> {
  UserCtrlNotifier(this._ref) : super((UsersModel.empty, false));

  final Ref _ref;
  final userNameCtrl = TextEditingController();

  UserRepo get _repo => _ref.watch(userRepoProvider);

  _init() async {
    final res = await _repo.getCurrentUser();

    state = (res, false);

    userNameCtrl.text = state.$1.userName;
  }

  selectImage() async {}

  updateUser(BuildContext context) async {
    state = (state.$1.copyWith(userName: userNameCtrl.text), false);
    final res = await _repo.updateUser(state.$1);

    res.fold(
      (l) => context.showOverLay.showError(l.message),
      (r) => context.showOverLay.showSuccess(r),
    );
  }

  toggleEditing() {
    state = (state.$1, !state.$2);
  }
}
