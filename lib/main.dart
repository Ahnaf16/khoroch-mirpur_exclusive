import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/src/khoroch.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:khoroch/theme/theme.dart';

void main() {
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
