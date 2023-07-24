import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:khoroch/View/home/app_drawer.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/routes/route_config.dart';
import 'package:khoroch/services/providers/groups_provider.dart';
import 'package:khoroch/services/providers/providers.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupProvider);

    final img = getUser?.photoURL;
    return SafeArea(
      child: Scaffold(
        appBar: KAppBar(
          title: 'KHARAC',
          leading: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: NeuContainer(
                  decoration:
                      AppTheme.decoration(context, useRound: true).copyWith(
                    image: DecorationImage(
                      image: KCachedImg(url: img!).provider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: groups.when(
            error: ErrorView.errorMathod,
            loading: Loader.loading,
            data: (data) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: MasonryGridView.builder(
                  shrinkWrap: true,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final group = data[index];
                    return InkWell(
                      onTap: () => context.pushTo(RouteName.group(group.id)),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: AppTheme.decoration(context),
                        child: Column(
                          children: [
                            Text(
                              group.name,
                              style: context.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  group.totalExpanse.toCurrency,
                                  style: context.textTheme.titleMedium,
                                ),
                                const Text('  of  '),
                                Text(
                                  group.cashAmount.values.sum.toCurrency,
                                  style: context.textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              children: [
                                ...group.users.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      backgroundColor: AppTheme.foregroundColor,
                                      radius: 10,
                                      child: KCachedImg(
                                        url: e.photo,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () => context.pushTo(RouteName.createGroup),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: AppTheme.decoration(context).copyWith(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Create Group'),
                SizedBox(width: 10),
                Icon(Icons.add_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
