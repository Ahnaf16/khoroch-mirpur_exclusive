import 'package:flutter/material.dart';
import 'package:khoroch/theme/theme.dart';

enum SnackType {
  info,
  loading,
  success,
  error;

  Widget get widget => switch (this) {
        info => _widget(Icons.info_outline_rounded),
        success => _widget(Icons.check_rounded),
        error => _widget(Icons.error_outline),
        loading => Center(
            child: CircularProgressIndicator(
              backgroundColor: AppTheme.backgroundColor,
              color: AppTheme.defContentColor,
            ),
          ),
      };

  _widget(IconData icon) {
    return Center(
      child: Icon(Icons.info_outline_rounded, color: AppTheme.defContentColor),
    );
  }
}
