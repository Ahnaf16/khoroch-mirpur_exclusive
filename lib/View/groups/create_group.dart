import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/services/controllers/group_ctrl.dart';
import 'package:khoroch/services/providers/auth_provider.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class CreateGroup extends ConsumerWidget {
  const CreateGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupCtrlProvider);
    final groupCtrl = ref.read(groupCtrlProvider.notifier);
    final userCtrl = ref.read(userCtrlProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: AppTheme.neuDecoration,
                child: ClipRRect(
                  borderRadius: AppTheme.neuDecoration.borderRadius,
                  child: TextField(
                    controller: groupCtrl.nameCtrl,
                    cursorColor: Colors.grey.shade500,
                    decoration: const InputDecoration(
                      labelText: 'Group Name',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: AppTheme.neuDecoration,
                child: ClipRRect(
                  borderRadius: AppTheme.neuDecoration.borderRadius,
                  child: TextField(
                    controller: userCtrl.userMailCtrl,
                    cursorColor: Colors.grey.shade500,
                    decoration: InputDecoration(
                      labelText: 'User Mail',
                      suffixIcon: IconButton(
                        onPressed: () {
                          groupCtrl.searchUser(context);
                        },
                        icon: const Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text('Users', style: context.textTheme.bodyLarge),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const ScrollPhysics(),
                itemCount: group.users.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  final user = group.users[index];
                  final isMe = user.uid == getUser!.uid;
                  final name = '${user.name}${isMe ? ' (Me)' : ''}';
                  final role = group.roles[user.uid]!;
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: AppTheme.neuDecoration,
                    child: Row(
                      children: [
                        Container(
                          clipBehavior: Clip.none,
                          decoration: AppTheme.neuDecoration.copyWith(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                image: KCachedImg(url: user.photo).provider),
                          ),
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: context.textTheme.bodyLarge),
                            const SizedBox(height: 5),
                            Text(user.email),
                            const SizedBox(height: 5),
                            Text(role.title)
                          ],
                        ),
                        const Spacer(),
                        if (getUser!.uid != user.uid)
                          IconButton(
                            onPressed: () => groupCtrl.removeUser(user.uid),
                            icon: const Icon(Icons.remove_rounded),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              NeuButton(
                onTap: () => groupCtrl.createGroupe(context),
                height: 50,
                width: context.width / 2.5,
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddUserSheet extends ConsumerWidget {
  const AddUserSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userCtrlProvider);
    final groupCtrl = ref.read(groupCtrlProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          users.when(
            error: ErrorView.errorMathod,
            loading: () => const Loader(isList: true),
            data: (data) => ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var user = data[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: AppTheme.neuDecoration,
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.none,
                        decoration: AppTheme.neuDecoration.copyWith(
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
                      IconButton(
                        onPressed: () {
                          groupCtrl.addUser(user);
                          context.pop;
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
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
