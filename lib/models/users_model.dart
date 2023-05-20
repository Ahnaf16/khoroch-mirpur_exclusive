import 'package:cloud_firestore/cloud_firestore.dart';

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
  }) : total = collectedCash.fold(0, (previous, element) => previous + element);

  factory UsersModel.fromDoc(DocumentSnapshot doc) {
    return UsersModel(
      collectedCash: List<int>.from(doc['collectedCash']),
      name: doc['name'] ?? '',
      photo: doc['photo'],
      uid: doc['uid'] ?? '',
      role: Role.fromMap(doc['role']),
    );
  }

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      collectedCash: List<int>.from(map['collectedCash']),
      name: map['name'] ?? '',
      photo: map['photo'],
      uid: map['uid'] ?? '',
      role: Role.fromMap(map['role']),
    );
  }

  final List<int> collectedCash;
  final String name;
  final String photo;
  final Role role;
  final int total;
  final String uid;

  bool get canAdd => role == Role.owner;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'collectedCash': collectedCash});
    result.addAll({'name': name});
    result.addAll({'photo': photo});
    result.addAll({'uid': uid});
    result.addAll({'role': role.name});

    return result;
  }

  UsersModel copyWith({
    List<int>? collectedCash,
    String? name,
    String? photo,
    String? uid,
    Role? role,
  }) {
    return UsersModel(
      collectedCash: collectedCash ?? this.collectedCash,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      uid: uid ?? this.uid,
      role: role ?? this.role,
    );
  }
}
