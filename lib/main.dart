import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/firebase_options.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:khoroch/routes/route_config.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Routemaster.setPathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'khoroch',
      builder: EasyLoading.init(),
      theme: AppTheme.theme,
      routeInformationParser: const RoutemasterParser(),
      routerDelegate: routes,
    );
  }
}
