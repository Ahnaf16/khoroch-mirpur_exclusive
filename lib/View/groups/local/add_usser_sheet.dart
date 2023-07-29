import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class AddUserSheet extends ConsumerWidget {
  const AddUserSheet({this.gid, super.key});

  final String? gid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userListCtrlProvider);
    final groupCtrl = ref.read(groupCtrlProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          KTextBox(
            controller: groupCtrl.searchCtrl,
            labelText: 'Search User',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => groupCtrl.searchCtrl.clear(),
                  icon: const Icon(Icons.clear_rounded),
                ),
                IconButton(
                  onPressed: () => groupCtrl.searchUser(context),
                  icon: const Icon(Icons.search_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          users.when(
            error: ErrorView.errorMathod,
            loading: () => const Loader(isList: true),
            data: (data) => ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var user = data[index];
                return InkWell(
                  onTap: () {
                    if (gid != null) {
                      groupCtrl.updateNewUser(context, gid!, user);
                    } else {
                      groupCtrl.addUser(user);
                      context.pop;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: AppTheme.decoration(context),
                    child: Row(
                      children: [
                        Container(
                          clipBehavior: Clip.none,
                          decoration: AppTheme.decoration(context).copyWith(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                image: KCachedImg(url: user.photo).provider),
                          ),
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: context.textTheme.bodyLarge),
                            const SizedBox(height: 5),
                            Text(user.email),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
