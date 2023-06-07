import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

enum Role {
  owner,
  viewer;

  factory Role.fromMap(String role) => role == 'owner' ? owner : viewer;
}

class UsersModel {
  UsersModel({
    required this.collectedCash,
    required this.name,
    required this.photo,
    required this.uid,
    required this.role,
    required this.email,
  }) : total = collectedCash.map((e) => e.amount).sum;

  factory UsersModel.fromDoc(DocumentSnapshot doc) {
    return UsersModel(
      collectedCash: List<CashCollection>.from(
          doc['collectedCash']?.map((x) => CashCollection.fromMap(x))),
      name: doc['name'] ?? '',
      photo: doc['photo'],
      uid: doc['uid'] ?? '',
      role: Role.fromMap(doc['role']),
      email: doc['email'] ?? '',
    );
  }

  factory UsersModel.fromJson(String source) =>
      UsersModel.fromMap(json.decode(source));

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      collectedCash: List<CashCollection>.from(
          map['collectedCash']?.map((x) => CashCollection.fromMap(x))),
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photo: map['photo'] ?? '',
      role: Role.fromMap(map['role']),
      uid: map['uid'] ?? '',
    );
  }

  final List<CashCollection> collectedCash;
  final String email;
  final String name;
  final String photo;
  final Role role;
  final int total;
  final String uid;

  bool get canAdd => role == Role.owner;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll(
        {'collectedCash': collectedCash.map((x) => x.toMap()).toList()});
    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'photo': photo});
    result.addAll({'total': total});
    result.addAll({'uid': uid});

    return result;
  }

  UsersModel copyWith({
    List<CashCollection>? collectedCash,
    String? name,
    String? photo,
    String? uid,
    String? email,
    Role? role,
  }) {
    return UsersModel(
      collectedCash: collectedCash ?? this.collectedCash,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      uid: uid ?? this.uid,
      role: role ?? this.role,
      email: email ?? this.email,
    );
  }

  String toJson() => json.encode(toMap());
}

class CashCollection {
  CashCollection({
    required this.amount,
    required this.date,
  });

  factory CashCollection.fromMap(Map<String, dynamic> map) {
    return CashCollection(
      amount: map['amount']?.toInt() ?? 0,
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  final int amount;
  final DateTime date;

  CashCollection copyWith({
    int? amount,
    DateTime? date,
  }) {
    return CashCollection(
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'amount': amount});
    result.addAll({'date': date.millisecondsSinceEpoch});

    return result;
  }
}
