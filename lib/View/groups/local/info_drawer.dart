import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/groups/local/add_usser_sheet.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/models/models.dart';
import 'package:khoroch/routes/route_config.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/services/providers/providers.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupInfoDrawer extends ConsumerWidget {
  const GroupInfoDrawer({
    super.key,
    required this.group,
  });

  final GroupModel group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupCtrl = ref.read(groupCtrlProvider.notifier);

    return NeuContainer(
      decoration: AppTheme.decoration(context).copyWith(
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(20),
          right: Radius.circular(0),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: context.width / 1.5,
      child: ListView(
        children: [
          const SizedBox(height: 10),
          NeuListTile(
            onTap: () {
              context.pop;
              if (group.ownerId == getUser!.uid) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const AddUserSheet(),
                );
              } else {
                context.pop;
                context.showError('Dose not Have Permission');
              }
            },
            leading: const Icon(
              Icons.person_add_alt_1_rounded,
            ),
            title: const Text('Add User'),
          ),
          NeuListTile(
            onTap: () {
              context.pushTo(
                RouteName.trash(group.id),
                quarry: {'owner': group.ownerId},
              );
            },
            leading: const Icon(
              Icons.delete_rounded,
            ),
            title: const Text('Trash'),
          ),
          NeuListTile(
            onTap: () {
              context.pop;
              if (group.ownerId == getUser!.uid) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are You Sure'),
                    content: const Text('This can not be undone!!'),
                    actions: [
                      NeuButton(
                        onTap: () => context.pop,
                        height: 50,
                        width: 50,
                        child: const Icon(
                          Icons.close_rounded,
                        ),
                      ),
                      NeuButton(
                        height: 50,
                        width: 80,
                        onTap: () => groupCtrl.deleteGroup(context, group.id),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              } else {
                context.showError('Dose not Have Permission');
              }
            },
            leading: const Icon(
              Icons.delete_forever_rounded,
            ),
            title: const Text('Delete Group'),
          ),
          const Divider(height: 50),
          Center(
            child: Text(
              'Members',
              style: context.textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 10),
          ...group.users.map(
            (user) => NeuListTile(
              onTap: () =>
                  context.pushTo(RouteName.userFromGroup(group.id, user.uid)),
              highLight: getUser?.uid == user.uid,
              leading: Hero(
                tag: user.uid,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: KCachedImg(url: user.photo).provider,
                        ),
                      ),
                    ),
                    if (group.ownerId == user.uid)
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: Icon(
                          MdiIcons.shieldAccount,
                          size: 18,
                          color: AppTheme.successColor,
                        ),
                      ),
                  ],
                ),
              ),
              title: Text(user.name),
              subtitle: Text(group.cashAmount[user.uid]!.toCurrency),
              subtitleStyle: context.textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}
