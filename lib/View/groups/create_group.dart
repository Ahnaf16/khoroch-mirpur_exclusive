import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/groups/local/add_usser_sheet.dart';
import 'package:khoroch/core/core.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/services/providers/auth_provider.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class CreateGroup extends ConsumerWidget {
  const CreateGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupCtrlProvider);
    final groupCtrl = ref.read(groupCtrlProvider.notifier);

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
              KTextBox(
                controller: groupCtrl.nameCtrl,
                labelText: 'Group Name',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Users', style: context.textTheme.titleLarge),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => const AddUserSheet(),
                      ),
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
