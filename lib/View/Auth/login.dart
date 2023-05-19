import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:khoroch/services/services.dart';
import 'package:khoroch/widgets/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authCtrlProvider);
    final authCtrl = ref.read(authCtrlProvider.notifier);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 150,
              ),
              NeuButton.social(
                onTap: () => authCtrl.login(context),
                icon: MdiIcons.google,
                showLoading: authState == AuthState.loading,
                socialName: 'Google',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
