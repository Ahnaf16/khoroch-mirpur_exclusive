import 'package:cloud_firestore/cloud_firestore.dart';

enum ExpendStatus {
  pending,
  approved,
  rejected;

  factory ExpendStatus.fromMap(String status) => values.byName(status);
}

class ExpendModel {
  ExpendModel({
    required this.amount,
    required this.item,
    required this.status,
    required this.date,
  });

  factory ExpendModel.fromDoc(DocumentSnapshot doc) {
    return ExpendModel(
      amount: doc['amount'] ?? 0,
      item: doc['item'] ?? '',
      date: (doc['date'] as Timestamp).toDate(),
      status: ExpendStatus.fromMap(doc['status']),
    );
  }

  factory ExpendModel.fromMap(Map<String, dynamic> map) {
    return ExpendModel(
      amount: map['amount']?.toInt() ?? 0,
      item: map['item'] ?? '',
      status: ExpendStatus.fromMap(map['status']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  static ExpendModel empty = ExpendModel(
    amount: 0,
    item: '',
    date: DateTime.now(),
    status: ExpendStatus.approved,
  );

  final int amount;
  final DateTime date;
  final String item;
  final ExpendStatus status;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'amount': amount});
    result.addAll({'item': item});
    result.addAll({'status': status.name});
    result.addAll({'date': date.millisecondsSinceEpoch});

    return result;
  }

  ExpendModel copyWith({
    int? amount,
    String? item,
    ExpendStatus? status,
    DateTime? date,
  }) {
    return ExpendModel(
      amount: amount ?? this.amount,
      item: item ?? this.item,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}
