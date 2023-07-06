import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/services/Controllers/trash_ctrl.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/expand_tile.dart';
import 'package:khoroch/widgets/widgets.dart';

class TrashView extends ConsumerWidget {
  const TrashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashData = ref.watch(trashProvider);
    final trashCtrl = ref.read(trashProvider.notifier);
    final currentUserData = ref.watch(currentUserProvider);
    var user = currentUserData.value;

    final canAdd = switch (user) {
      null => false,
      _ when user.canAdd => true,
      _ => false,
    };
    return SafeArea(
      child: Scaffold(
        appBar: KAppBar(
          title: 'Trash',
          actions: [
            IconButton.filled(
              onPressed: () => context.rPop,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        floatingActionButton: canAdd
            ? GestureDetector(
                onTap: () => trashCtrl.clearAll(),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: AppTheme.neuDecoration.copyWith(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_forever_rounded),
                ),
              )
            : null,
        body: trashData.when(
          error: ErrorView.errorMathod,
          loading: () => const Loader(isList: true),
          data: (trashes) => RefreshIndicator(
            color: AppTheme.defContentColor,
            backgroundColor: AppTheme.backgroundColor,
            onRefresh: () => trashCtrl.reload(),
            child: ListView.builder(
              itemCount: trashes.length,
              itemBuilder: (BuildContext context, int index) {
                final trash = trashes[index];
                return Slidable(
                  enabled: canAdd,
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => trashCtrl.restore(trash),
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: Colors.blue.withOpacity(.1),
                        foregroundColor: Colors.blue,
                        icon: Icons.restore_from_trash_rounded,
                        label: 'Restore',
                        autoClose: true,
                      ),
                      SlidableAction(
                        onPressed: (context) =>
                            trashCtrl.deleteForever(trash.docId),
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: Colors.red.withOpacity(.1),
                        foregroundColor: Colors.red,
                        icon: Icons.delete_forever,
                        label: 'Delete',
                        autoClose: true,
                      ),
                    ],
                  ),
                  child: ExpandTile(expense: trashes[index], canAdd: false),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
