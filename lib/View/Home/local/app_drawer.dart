import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/core/core.dart';
import 'package:khoroch/routes/route_config.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/theme/theme.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = ref.read(authCtrlProvider.notifier);
    return Container(
      decoration: AppTheme.neuDecoration,
      width: context.width / 1.5,
      child: ListView(
        children: [
          NeuListTile(
            onTap: () {
              context.pushTo(RouteName.trash);
            },
            leading: const Icon(Icons.delete_outline_rounded),
            title: const Text('Trash'),
          ),
          NeuListTile(
            onTap: () => authCtrl.logOut(),
            leading: const Icon(Icons.logout_rounded),
            title: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }
}

class NeuListTile extends StatelessWidget {
  const NeuListTile({
    super.key,
    this.leading,
    this.title,
    this.trailing,
    this.onTap,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: AppTheme.neuDecoration,
        child: Row(
          children: [
            if (leading != null) leading!,
            const SizedBox(width: 10),
            if (title != null) title!,
            const Spacer(),
            const SizedBox(width: 10),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
