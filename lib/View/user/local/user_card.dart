import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/users_model.dart';
import 'package:khoroch/routes/route_config.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class UserCard extends ConsumerWidget {
  const UserCard({super.key, required this.user});

  final UsersModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashCollections = ref.watch(cashCollectionsProvider(user.uid));
    return GestureDetector(
      onTap: () {
        context.pushTo(RouteName.user(user.uid));
      },
      child: cashCollections.when(
          error: ErrorView.errorMathod,
          loading: () => const Loader(isList: false),
          data: (cash) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  decoration: AppTheme.neuDecoration.copyWith(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Hero(
                        tag: user.uid,
                        child: Container(
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
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.name.split(' ').first,
                            style: context.textTheme.bodyLarge,
                          ),
                          if (user.canAdd)
                            const Icon(
                              Icons.verified_outlined,
                              size: 18,
                            ),
                        ],
                      ),
                      // const SizedBox(height: 10),
                      Text(
                        cash.map((e) => e.amount).sum.toCurrency,
                        style: context.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
