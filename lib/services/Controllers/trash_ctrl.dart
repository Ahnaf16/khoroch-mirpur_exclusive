import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/models/models.dart';

final trashProvider = StateNotifierProvider.autoDispose<TrashNotifier,
    AsyncValue<List<ExpenseModel>>>((ref) {
  return TrashNotifier().._init();
});

class TrashNotifier extends StateNotifier<AsyncValue<List<ExpenseModel>>> {
  TrashNotifier() : super(const AsyncValue.loading());

  final _fire = FirebaseFirestore.instance;

  _init() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async {
        final snap = await _fire
            .collection(FirePath.expend)
            .where('toBeDeleted', isEqualTo: true)
            .orderBy('date', descending: true)
            .get();

        final expenditure =
            snap.docs.map((e) => ExpenseModel.fromDoc(e)).toList();
        return expenditure;
      },
    );
  }

  reload() async => await _init();

  deleteForever(String id) async {
    final doc = _fire.collection(FirePath.expend).doc(id);
    await doc.delete();
    await reload();
  }

  clearAll() async {
    final batch = _fire.batch();
    final data = state.value;

    if (data == null) {
      return 0;
    }

    for (var element in data) {
      final doc = _fire.collection(FirePath.expend).doc(element.docId);
      batch.delete(doc);
    }

    await batch.commit();
    await reload();
  }

  restore(ExpenseModel expense) async {
    final doc = _fire.collection(FirePath.expend).doc(expense.docId);
    final updated = expense.copyWith(toBeDeleted: false);
    doc.update(updated.toMap());

    await reload();
  }
}
