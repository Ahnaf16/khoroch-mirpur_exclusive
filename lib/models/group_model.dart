import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:khoroch/models/models.dart';

class GroupModel {
  GroupModel({
    required this.id,
    required this.name,
    required this.totalExpanse,
    required this.roles,
    required this.cashAmount,
    required this.users,
    required this.usersId,
  });

  factory GroupModel.fromDoc(DocumentSnapshot doc) {
    final parsed = (doc['roles'] as Map)
        .map((key, value) => MapEntry(key, GroupRole.fromMap(value)));

    return GroupModel(
      id: doc['id'],
      name: doc['name'] ?? '',
      totalExpanse: doc['totalExpanse'],
      users: List<UsersModel>.from(
          doc['users']?.map((x) => UsersModel.fromMap(x))),
      roles: Map<String, GroupRole>.from(parsed),
      cashAmount: Map<String, int>.from(doc['cashAmount']),
      usersId: List<String>.from(doc['usersId']),
    );
  }

  static GroupModel empty = GroupModel(
    id: '',
    name: '',
    totalExpanse: 0,
    users: [],
    usersId: [],
    roles: {},
    cashAmount: {},
  );

  final String id;
  final String name;
  final int totalExpanse;
  final Map<String, GroupRole> roles;
  final Map<String, int> cashAmount;
  final List<UsersModel> users;
  final List<String> usersId;

  String get ownerId => roles.entries
      .where((element) => element.value == GroupRole.owner)
      .first
      .key;

  GroupModel copyWith({
    String? id,
    String? name,
    int? totalExpanse,
    Map<String, GroupRole>? roles,
    Map<String, int>? cashAmount,
    List<UsersModel>? users,
    List<String>? usersId,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      totalExpanse: totalExpanse ?? this.totalExpanse,
      roles: roles ?? this.roles,
      cashAmount: cashAmount ?? this.cashAmount,
      users: users ?? this.users,
      usersId: usersId ?? this.usersId,
    );
  }

  Map<String, dynamic> toMap() {
    final parsed = roles.map((key, value) => MapEntry(key, value.name));
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'totalExpanse': totalExpanse});
    result.addAll({'roles': parsed});
    result.addAll({'cashAmount': cashAmount});
    result.addAll({'users': users.map((x) => x.toMap()).toList()});
    result.addAll({'usersId': usersId});

    return result;
  }
}
