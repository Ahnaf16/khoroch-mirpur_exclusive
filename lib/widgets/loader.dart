import 'package:flutter/material.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/enums.dart';
import 'package:khoroch/theme/theme.dart';

import 'package:khoroch/widgets/widgets.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    required this.isList,
  });

  final bool isList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isList)
          Column(
            children: [
              ...List.generate(
                5,
                (index) => KShimmer.card(
                  height: 50,
                  width: double.maxFinite,
                ),
              )
            ],
          )
        else
          KShimmer.card(
            height: 150,
            width: double.maxFinite,
          ),
      ],
    );
  }
}

class OverlayLoader {
  static OverlayEntry? _overlayEntry;
  static bool _onScreen = false;

  static bool isLoaderOn() => _onScreen;

  static void show(BuildContext context, {String message = ''}) {
    _show(context, message: message, type: SnackType.loading);
  }

  // ToDo
  // static void showToast(BuildContext context, {String message = ''}) {
  // }

  static void showError(BuildContext context, {String message = ''}) {
    _show(context, message: message, type: SnackType.error);
  }

  static void showInfo(BuildContext context, {String message = ''}) {
    _show(context, message: message, type: SnackType.info);
  }

  static void showSuccess(BuildContext context, {String message = ''}) {
    _show(context, message: message, type: SnackType.success);
  }

  static void _show(BuildContext context,
      {String message = '', required SnackType type}) async {
    FocusScope.of(context).requestFocus(FocusNode());

    remove(context);

    _overlayEntry = createOverlayEntry(context, message: message, type: type);
    Overlay.of(context).insert(_overlayEntry!);
    _onScreen = true;
    await Future.delayed(const Duration(milliseconds: 3000));
    remove(context);
  }

  static void remove(BuildContext context) {
    if (_onScreen) {
      _overlayEntry!.remove();
      _onScreen = false;
    }
  }

  // Loader can be changed from here
  static OverlayEntry createOverlayEntry(BuildContext context,
      {String message = '',
      Alignment alignment = Alignment.center,
      required SnackType type}) {
    return OverlayEntry(
      builder: (context) => Align(
        alignment: alignment,
        child: Container(
          height: context.height / 7,
          width: context.width / 2,
          decoration: AppTheme.neuDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (type == SnackType.loading)
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: AppTheme.backgroundColor,
                    color: AppTheme.defContentColor,
                  ),
                )
              else if (type == SnackType.info)
                Center(
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: AppTheme.defContentColor,
                  ),
                )
              else if (type == SnackType.error)
                Center(
                  child: Icon(
                    Icons.error_outline,
                    color: AppTheme.defContentColor,
                  ),
                )
              else
                Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: AppTheme.defContentColor,
                  ),
                ),
              const SizedBox(height: 15),
              Text(
                message,
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
