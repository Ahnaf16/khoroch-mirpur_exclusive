import 'package:cloud_firestore/cloud_firestore.dart';

class ExpendModel {
  ExpendModel({
    required this.item,
    required this.amount,
    required this.date,
  });

  factory ExpendModel.fromDoc(DocumentSnapshot doc) {
    return ExpendModel(
      amount: doc['amount'] ?? 0,
      item: doc['item'] ?? '',
      date: (doc['date'] as Timestamp).toDate(),
    );
  }

  final int amount;
  final String item;
  final DateTime date;

  @override
  String toString() => '''
     amount: $item,
     item: $amount,
     date: $date
    ''';

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'amount': amount});
    result.addAll({'item': item});
    result.addAll({'date': date});

    return result;
  }

  ExpendModel copyWith({
    int? amount,
    String? item,
    DateTime? date,
  }) {
    return ExpendModel(
      amount: amount ?? this.amount,
      item: item ?? this.item,
      date: date ?? this.date,
    );
  }

  static ExpendModel empty = ExpendModel(
    amount: 0,
    item: '',
    date: DateTime.now(),
  );
}
