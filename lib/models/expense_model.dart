import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:khoroch/models/models.dart';

enum ExpenseStatus {
  pending,
  approved,
  rejected;

  factory ExpenseStatus.fromMap(String status) => values.byName(status);

  IconData get icon => switch (this) {
        pending => Icons.pending_outlined,
        approved => Icons.done_rounded,
        rejected => Icons.cancel_outlined,
      };
}

class ExpenseModel {
  ExpenseModel({
    required this.amount,
    required this.item,
    required this.status,
    required this.date,
    required this.addedBy,
    required this.docId,
  });

  factory ExpenseModel.fromDoc(DocumentSnapshot doc) {
    return ExpenseModel(
      amount: doc['amount'] ?? 0,
      item: doc['item'] ?? '',
      date: (doc['date'] as Timestamp).toDate(),
      status: ExpenseStatus.fromMap(doc['status']),
      addedBy: UsersModel.fromMap(doc['addedBy']),
      docId: doc['id'],
    );
  }

  static ExpenseModel empty = ExpenseModel(
    amount: 0,
    item: '',
    date: DateTime.now(),
    status: ExpenseStatus.pending,
    addedBy: null,
    docId: '',
  );

  final int amount;
  final DateTime date;
  final String item;
  final ExpenseStatus status;
  final String docId;
  final UsersModel? addedBy;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'amount': amount});
    result.addAll({'item': item});
    result.addAll({'status': status.name});
    result.addAll({'date': date});
    result.addAll({'addedBy': addedBy?.toMap()});
    result.addAll({'id': docId});

    return result;
  }

  ExpenseModel copyWith({
    int? amount,
    String? item,
    ExpenseStatus? status,
    DateTime? date,
    UsersModel? addedBy,
    String? docId,
  }) {
    return ExpenseModel(
      amount: amount ?? this.amount,
      item: item ?? this.item,
      status: status ?? this.status,
      date: date ?? this.date,
      addedBy: addedBy ?? this.addedBy,
      docId: docId ?? this.docId,
    );
  }
}
