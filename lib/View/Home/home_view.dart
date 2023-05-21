import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/Home/local/balance_card.dart';

import 'package:khoroch/View/Home/local/expense_sheet.dart';
import 'package:khoroch/View/Home/local/expenditure_list.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/enums.dart';
import 'package:khoroch/services/services.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<dynamic> showAddExpanseSheet(BuildContext context, Intend intend) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddExpanseSheet(intend: intend),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expendData = ref.watch(expenditureProvider);
    final userData = ref.watch(userProvider);
    final authCtrl = ref.read(authCtrlProvider.notifier);

    final img = getUser?.photoURL;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: KAppBar(
          title: 'KHARAC',
          actions: [
            if (img != null)
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      clipBehavior: Clip.none,
                      decoration: AppTheme.neuDecoration.copyWith(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: KCachedImg(url: img).provider),
                      ),
                      height: 50,
                      width: 50,
                    ),
                  );
                },
              ),
          ],
        ),
        drawer: Container(
          decoration: AppTheme.neuDecoration,
          width: context.width / 1.5,
          child: ListView(
            children: [
              TextButton.icon(
                onPressed: () {
                  authCtrl.logOut();
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('LOGOUT'),
              ),
            ],
          ),
        ),
        body: expendData.when(
          error: (error, stackTrace) {
            log(error.toString());
            return const Center(child: Text('E R R O R'));
          },
          loading: () => const Loader(isList: true),
          data: (expenders) {
            final totalExp = expenders.map((e) => e.amount).sum;
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  BalanceCard(totalExp: totalExp),
                  const SizedBox(height: 10),
                  Text(
                    'Expenditure',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                  ExpenditureList(expenders: expenders)
                ],
              ),
            );
          },
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: userData.when(
            error: (error, stackTrace) =>
                const Center(child: Text('E R R O R')),
            loading: () => const Loader(),
            data: (user) {
              final intend = user != null
                  ? user.canAdd
                      ? Intend.add
                      : Intend.request
                  : Intend.request;

              return GestureDetector(
                onTap: () => showAddExpanseSheet(context, intend),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: AppTheme.neuDecoration.copyWith(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(intend.name),
                      const SizedBox(width: 10),
                      const Icon(Icons.add_rounded),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
