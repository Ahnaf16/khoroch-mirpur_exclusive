import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/firebase_options.dart';
import 'package:khoroch/src/khoroch_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:khoroch/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'khoroch',
      home: const KhorochPage(),
      builder: EasyLoading.init(),
      theme: AppTheme.theme,
    );
  }
}
