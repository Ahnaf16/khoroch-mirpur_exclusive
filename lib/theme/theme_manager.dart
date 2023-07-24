import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier().._init();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  final _pref = SharedPreferences.getInstance();
  final _prefKey = 'isDarkMode';

  _init() async {
    final pref = await _pref;

    final isDark = pref.getBool(_prefKey);

    state = switch (isDark) {
      null => ThemeMode.system,
      true => ThemeMode.dark,
      false => ThemeMode.light,
    };
  }

  setThemeMode(bool isDark) async {
    log(isDark.toString());
    final pref = await _pref;
    await pref.setBool(_prefKey, isDark);
    await _init();
  }
}
