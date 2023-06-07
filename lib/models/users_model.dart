import 'package:cloud_firestore/cloud_firestore.dart';

enum Role {
  owner,
  viewer;

  factory Role.fromMap(String role) => role == 'owner' ? owner : viewer;
}

class UsersModel {
  UsersModel({
    required this.name,
    required this.photo,
    required this.uid,
    required this.role,
    required this.email,
  });

  factory UsersModel.fromDoc(DocumentSnapshot doc) {
    return UsersModel(
      name: doc['name'] ?? '',
      photo: doc['photo'],
      uid: doc['uid'] ?? '',
      role: Role.fromMap(doc['role']),
      email: doc['email'] ?? '',
    );
  }

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photo: map['photo'] ?? '',
      role: Role.fromMap(map['role']),
      uid: map['uid'] ?? '',
    );
  }

  final String email;
  final String name;
  final String photo;
  final Role role;
  final String uid;

  bool get canAdd => role == Role.owner;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'photo': photo});
    result.addAll({'uid': uid});
    result.addAll({'role': role.name});

    return result;
  }

  UsersModel copyWith({
    String? name,
    String? photo,
    String? uid,
    String? email,
    Role? role,
  }) {
    return UsersModel(
      name: name ?? this.name,
      photo: photo ?? this.photo,
      uid: uid ?? this.uid,
      role: role ?? this.role,
      email: email ?? this.email,
    );
  }
}

class CashCollection {
  const CashCollection({
    required this.amount,
    required this.date,
    required this.id,
  });

  factory CashCollection.fromMap(Map<String, dynamic> map) {
    return CashCollection(
      amount: map['amount']?.toInt() ?? 0,
      date: (map['date'] as Timestamp).toDate(),
      id: map['id'],
    );
  }

  factory CashCollection.fromDoc(DocumentSnapshot doc) {
    return CashCollection(
      amount: doc['amount']?.toInt() ?? 0,
      date: (doc['date'] as Timestamp).toDate(),
      id: doc['id'],
    );
  }

  final int amount;
  final DateTime date;
  final String id;

  CashCollection copyWith({
    int? amount,
    DateTime? date,
    String? id,
  }) {
    return CashCollection(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'amount': amount});
    result.addAll({'date': date});
    result.addAll({'id': id});

    return result;
  }

  static CashCollection empty =
      CashCollection(amount: 0, date: DateTime.now(), id: '');
}
