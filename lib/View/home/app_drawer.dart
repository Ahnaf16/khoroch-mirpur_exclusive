import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/core/core.dart';
import 'package:khoroch/routes/route_config.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/services/providers/auth_provider.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/theme/theme_manager.dart';
import 'package:khoroch/widgets/widgets.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCtrl = ref.read(authCtrlProvider.notifier);
    final themeCtrl = ref.read(themeModeProvider.notifier);
    return NeuContainer(
      decoration: AppTheme.decoration(context).copyWith(
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(0),
          right: Radius.circular(20),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: context.width / 1.5,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 10),
                Stack(
                  children: [
                    NeuContainer(
                      decoration: AppTheme.decoration(context),
                      margin: const EdgeInsets.all(20),
                      child: KCachedImg(
                        url: getUser!.photoURL!,
                        width: double.maxFinite,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: InkWell(
                        onTap: () => context.pushTo(RouteName.profile),
                        child: NeuContainer(
                          padding: const EdgeInsets.all(5),
                          decoration:
                              AppTheme.decoration(context, useRound: true),
                          child: const Icon(Icons.edit_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                NeuListTile(
                  onTap: () => themeCtrl.setThemeMode(!context.isDark),
                  leading: Icon(
                    context.isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                  ),
                  title: context.isDark
                      ? const Text('Enable light theme')
                      : const Text('Enable dark theme'),
                  trailing: Switch(
                    value: context.isDark,
                    onChanged: (value) => themeCtrl.setThemeMode(value),
                  ),
                ),
              ],
            ),
          ),
          NeuListTile(
            onTap: () => authCtrl.logOut(),
            leading: const Icon(Icons.logout_rounded),
            title: const Text('LOGOUT'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
