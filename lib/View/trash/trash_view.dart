import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/services/providers/providers.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class TrashView extends ConsumerWidget {
  const TrashView(this.gid, this.owner, {super.key});

  final String gid;
  final String owner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashData = ref.watch(trashProvider(gid));
    final trashCtrl = ref.read(trashProvider(gid).notifier);

    final canAdd = owner == getUser!.uid;

    return SafeArea(
      child: Scaffold(
        appBar: const KAppBar(title: 'Trash'),
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
            onRefresh: () => Future(() => null), // trashCtrl.reload(),
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
                        onPressed: (context) =>
                            trashCtrl.restore(context, trash),
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
                  child: ExpandTile(
                    expense: trashes[index],
                    canAdd: false,
                    gid: gid,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
