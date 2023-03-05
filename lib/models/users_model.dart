import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  UsersModel({
    required this.name,
    required this.collectedCash,
  }) : total = collectedCash.fold(0, (previous, element) => previous + element);

  factory UsersModel.fromDoc(DocumentSnapshot doc) {
    return UsersModel(
      collectedCash: List<int>.from(doc['collectedCash']),
      name: doc['name'] ?? '',
    );
  }

  final List<int> collectedCash;
  final String name;
  final int total;

  @override
  String toString() => '''
     name: $name,
     collectedCash: $collectedCash,
     total: $total
    ''';

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'collectedCash': collectedCash});
    result.addAll({'name': name});

    return result;
  }
}
