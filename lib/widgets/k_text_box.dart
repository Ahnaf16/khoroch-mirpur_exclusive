import 'package:flutter/material.dart';
import 'package:khoroch/theme/theme.dart';

class KTextBox extends StatelessWidget {
  const KTextBox({
    super.key,
    this.controller,
    this.labelText,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String? labelText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.decoration(context),
      child: ClipRRect(
        borderRadius: AppTheme.decoration(context).borderRadius,
        child: TextField(
          controller: controller,
          cursorColor: Colors.grey.shade500,
          decoration: InputDecoration(
            labelText: labelText,
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }
}
