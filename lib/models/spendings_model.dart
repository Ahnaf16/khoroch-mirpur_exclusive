import 'package:cloud_firestore/cloud_firestore.dart';

class SpendingModel {
  SpendingModel({
    required this.item,
    required this.amount,
    required this.date,
  });

  factory SpendingModel.fromDoc(DocumentSnapshot doc) {
    return SpendingModel(
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

  SpendingModel copyWith({
    int? amount,
    String? item,
    DateTime? date,
  }) {
    return SpendingModel(
      amount: amount ?? this.amount,
      item: item ?? this.item,
      date: date ?? this.date,
    );
  }
}
