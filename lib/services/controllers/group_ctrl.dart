import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/services/repository/group_repo.dart';
import 'package:khoroch/services/repository/repository.dart';
import 'package:nanoid/nanoid.dart';

final groupCtrlProvider =
    StateNotifierProvider<GroupCtrlNotifier, GroupModel>((ref) {
  return GroupCtrlNotifier(ref).._init();
});

//! add group id from family provider
class GroupCtrlNotifier extends StateNotifier<GroupModel> {
  GroupCtrlNotifier(this._ref) : super(GroupModel.empty);

  final Ref _ref;

  final nameCtrl = TextEditingController();
  final searchCtrl = TextEditingController();

  UserRepo get _userRepo => _ref.watch(userRepoProvider);
  GroupRepo get _repo => _ref.watch(groupRepoProvider);

  _init() async {
    final user = await _userRepo.getCurrentUser();
    state = state.copyWith(
      users: [...state.users, user],
      usersId: [...state.usersId, user.uid],
      roles: {...state.roles, user.uid: GroupRole.owner},
      cashAmount: {...state.cashAmount, user.uid: 0},
    );
  }

  createGroupe(BuildContext context) async {
    if (!state.roles.values.contains(GroupRole.owner)) {
      context.showOverLay.showError('No Owner');
      _init();
      return 0;
    }
    if (nameCtrl.text.isEmpty) {
      context.showOverLay.showError('Enter Group Name');
      return 0;
    }

    context.showOverLay.show('Creating Group');
    state = state.copyWith(name: nameCtrl.text, id: nanoid());

    final res = await _repo.createGroup(state);

    res.fold(
      (l) => context.showOverLay.showError(l.message),
      (r) => context.showOverLay.showSuccess(r),
    );

    if (res.isRight()) {
      context.rPop;
      clear();
    }
  }

  updateUserCash(
    BuildContext context,
    String groupId,
    String uid,
    int amount,
    bool isAdd,
  ) async {
    final group = await _repo.getGroup(groupId);

    final cashAmount = switch (isAdd) {
      true => group.cashAmount[uid]! + amount,
      false => group.cashAmount[uid]! - amount
    };

    final cashAmounts = group.cashAmount;

    cashAmounts[uid] = cashAmount;

    log(cashAmounts[uid].toString());

    final updatedGroup = group.copyWith(cashAmount: cashAmounts);

    final res = await _repo.updateGroup(updatedGroup);

    res.fold(
      (l) => context.showOverLay.showError(l.message),
      (r) => context.showOverLay.showSuccess(r),
    );
  }

  updateTotalExpanse(
    BuildContext context,
    String groupId,
    int amount,
    bool isAdd,
  ) async {
    final group = await _repo.getGroup(groupId);

    final total = switch (isAdd) {
      true => group.totalExpanse + amount,
      false => group.totalExpanse - amount
    };

    final updatedGroup = group.copyWith(totalExpanse: total);

    final res = await _repo.updateGroup(updatedGroup);

    res.fold(
      (l) => context.showOverLay.showError(l.message),
      (r) => context.showOverLay.showSuccess(r),
    );
  }

  updateNewUser(
      BuildContext context, String groupId, int amount, bool isAdd) async {
    final group = await _repo.getGroup(groupId);

    final total = switch (isAdd) {
      true => group.totalExpanse + amount,
      false => group.totalExpanse - amount
    };

    final updatedGroup = group.copyWith(totalExpanse: total);

    final res = await _repo.updateGroup(updatedGroup);

    res.fold(
      (l) => context.showOverLay.showError(l.message),
      (r) => context.showOverLay.showSuccess(r),
    );
  }

  clear() {
    state = GroupModel.empty;
    nameCtrl.clear();
    _init();
  }

  searchUser(BuildContext context) {
    context.removeFocus();

    final userCtrl = _ref.read(userCtrlProvider.notifier);

    userCtrl.searchUser(searchCtrl.text);
  }

  addUser(UsersModel user) {
    final exist = state.users.any((element) => element.uid == user.uid);
    if (exist) return 0;

    state = state.copyWith(
      users: [...state.users, user],
      usersId: [...state.usersId, user.uid],
      roles: {...state.roles, user.uid: GroupRole.viewer},
      cashAmount: {...state.cashAmount, user.uid: 0},
    );
  }

  removeUser(String id) {
    final user = state.users;
    final userId = state.usersId;
    final roles = state.roles;
    final cash = state.cashAmount;

    user.removeWhere((element) => element.uid == id);
    userId.removeWhere((element) => element == id);
    roles.removeWhere((key, value) => key == id);
    cash.removeWhere((key, value) => key == id);

    state = state.copyWith(
      users: user,
      usersId: userId,
      roles: roles,
    );
  }

  deleteGroup(BuildContext context, String id) async {
    context.pop;
    context.rPop;

    final res = await _repo.deleteGroup(id);

    res.fold(
      (l) => context.showOverLay.showError(l.message),
      (r) => context.showOverLay.showSuccess(r),
    );
  }
}
