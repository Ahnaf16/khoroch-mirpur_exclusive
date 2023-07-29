import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khoroch/services/providers/auth_provider.dart';

enum GroupRole {
  owner,
  viewer;

  factory GroupRole.fromMap(String name) => values.byName(name);

  String get title => this == owner ? 'Owner' : 'Viewer';
}

class UsersModel {
  UsersModel({
    required this.email,
    required this.name,
    required this.photo,
    required this.uid,
    required this.userName,
  });

  factory UsersModel.fromDoc(DocumentSnapshot doc) {
    return UsersModel(
      name: doc['name'] ?? '',
      photo: doc['photo'],
      uid: doc['uid'] ?? '',
      email: doc['email'] ?? '',
      userName: doc['userName'],
    );
  }

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photo: map['photo'] ?? '',
      uid: map['uid'] ?? '',
      userName: map['userName'],
    );
  }

  static UsersModel empty = UsersModel(
    name: '',
    photo: getUser?.photoURL ?? '',
    uid: '',
    email: '',
    userName: '',
  );

  final String email;
  final String name;
  final String photo;
  final String uid;
  final String userName;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'photo': photo});
    result.addAll({'uid': uid});
    result.addAll({'userName': userName});

    return result;
  }

  UsersModel copyWith({
    String? name,
    String? photo,
    String? uid,
    String? email,
    String? userName,
  }) {
    return UsersModel(
      name: name ?? this.name,
      photo: photo ?? this.photo,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      userName: userName ?? this.userName,
    );
  }
}

class CashCollection {
  const CashCollection({
    required this.amount,
    required this.date,
    required this.id,
    required this.user,
  });

  factory CashCollection.fromDoc(DocumentSnapshot doc) {
    return CashCollection(
      amount: doc['amount']?.toInt() ?? 0,
      date: (doc['date'] as Timestamp).toDate(),
      id: doc['id'],
      user: UsersModel.fromMap(doc['user']),
    );
  }

  factory CashCollection.fromMap(Map<String, dynamic> map) {
    return CashCollection(
      amount: map['amount']?.toInt() ?? 0,
      date: (map['date'] as Timestamp).toDate(),
      id: map['id'],
      user: UsersModel.fromMap(map['user']),
    );
  }

  static CashCollection empty = CashCollection(
    amount: 0,
    date: DateTime.now(),
    id: '',
    user: UsersModel.empty,
  );

  final int amount;
  final DateTime date;
  final String id;
  final UsersModel user;

  CashCollection copyWith({
    int? amount,
    DateTime? date,
    String? id,
    UsersModel? user,
  }) {
    return CashCollection(
      amount: amount ?? this.amount,
      date: date ?? this.date,
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'amount': amount});
    result.addAll({'date': date});
    result.addAll({'id': id});
    result.addAll({'user': user.toMap()});

    return result;
  }
}
