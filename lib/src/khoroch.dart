import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/src/balance_card.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KhorochPage extends ConsumerStatefulWidget {
  const KhorochPage({super.key});

  @override
  ConsumerState<KhorochPage> createState() => _KhorochPageState();
}

class _KhorochPageState extends ConsumerState<KhorochPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          decoration: AppTheme.neuDecoration.copyWith(
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            'KHOROCH',
            style: context.textTheme.titleMedium?.copyWith(
              letterSpacing: 3,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const BalanceCard(),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: AppTheme.neuDecoration,
                  child: Row(
                    children: [
                      const Icon(MdiIcons.currencyBdt),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            2000.toCurrency,
                            style: context.textTheme.titleLarge,
                          ),
                          Text(
                            'vara',
                            style: context.textTheme.labelLarge,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        DateTime.now().formateDate(),
                        style: context.textTheme.labelLarge,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () async {
          final pref = await SharedPreferences.getInstance();
          pref.clear();
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: AppTheme.neuDecoration.copyWith(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.clear_all),
        ),
      ),
    );
  }
}
