import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/services/controllers/user_ctrl.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userCtrlProvider);
    final userCtrl = ref.read(userCtrlProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => userCtrl.toggleEditing(),
        child: const NeuContainer(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Icon(Icons.edit_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: NeuContainer(
                  decoration: AppTheme.decoration(context, useRound: true),
                  child: KCachedImg(
                    url: user.$1.photo,
                    radius: 180,
                    height: 100,
                    width: 100,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Name : ${user.$1.name}',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'Gmail : ${user.$1.email}',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              // if (user.$2)

              if (!user.$2)
                Text(
                  'User Name : ${user.$1.userName}',
                  style: context.textTheme.titleLarge,
                )
              else
                TextField(
                  focusNode: FocusNode()..requestFocus(),
                  controller: userCtrl.userNameCtrl,
                  style: context.textTheme.titleLarge,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    isCollapsed: true,
                    prefixText: 'User Name : ',
                    suffixIcon: InkWell(
                      onTap: () => userCtrl.updateUser(context),
                      child: const Icon(Icons.done_rounded),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
