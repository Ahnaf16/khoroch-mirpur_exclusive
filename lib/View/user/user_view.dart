import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class UserDetails extends ConsumerWidget {
  const UserDetails({required this.uid, super.key});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider(uid));
    return userData.when(
      error: (error, stackTrace) => const Center(child: Text('E R R O R')),
      loading: () => const Loader(isList: false),
      data: (user) {
        return Scaffold(
          appBar: KAppBar(
            title: user.name,
            actions: [
              IconButton.filled(
                onPressed: () => context.rPop,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: user.uid,
                      child: Container(
                        height: 100,
                        width: 100,
                        clipBehavior: Clip.none,
                        decoration: AppTheme.neuDecoration.copyWith(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: KCachedImg(
                              url: user.photo,
                            ).provider,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: context.textTheme.titleLarge),
                        const SizedBox(height: 10),
                        Text(user.email),
                        const SizedBox(height: 10),
                        Text('Total collected : ${user.total}'),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 50),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final collected = user.collectedCash[index];
                      return Container(
                        decoration: AppTheme.neuDecoration,
                        child: Text(collected.amount.toCurrency),
                      );
                    },
                    itemCount: user.collectedCash.length,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: AppTheme.neuDecoration.copyWith(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('A d d'),
                  SizedBox(width: 10),
                  Icon(Icons.add_rounded),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
