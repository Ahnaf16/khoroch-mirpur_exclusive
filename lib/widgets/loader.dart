import 'package:flutter/material.dart';
import 'package:khoroch/core/extensions.dart';
import 'package:khoroch/models/enums.dart';
import 'package:khoroch/theme/theme.dart';

class OverlayLoader {
  OverlayLoader(this.context);

  final BuildContext context;

  static bool _onScreen = false;
  static OverlayEntry? _overlayEntry;

  static bool isLoaderOn() => _onScreen;

  void show(String message) {
    _show(message: message, type: SnackType.loading);
  }

  // ToDo
  // static void showToast(BuildContext context, {String message = ''}) {
  // }

  void showError(String error) {
    _show(message: error, type: SnackType.error);
  }

  void showInfo(String message) {
    _show(message: message, type: SnackType.info);
  }

  void showSuccess(String message) {
    _show(message: message, type: SnackType.success);
  }

  void remove(BuildContext context) {
    if (_onScreen) {
      _overlayEntry!.remove();
      _onScreen = false;
    }
  }

  // Loader can be changed from here
  OverlayEntry createOverlayEntry({
    String message = '',
    Alignment alignment = Alignment.center,
    required SnackType type,
  }) {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () => remove(context),
        child: Align(
          alignment: alignment,
          child: Container(
            height: context.height / 7,
            width: context.width / 2,
            decoration: AppTheme.decoration(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                type.widget,
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
      ),
    );
  }

  void _show({String message = '', required SnackType type}) async {
    FocusScope.of(context).requestFocus(FocusNode());

    remove(context);

    _overlayEntry = createOverlayEntry(message: message, type: type);

    Overlay.of(context).insert(_overlayEntry!);

    _onScreen = true;

    await Future.delayed(const Duration(milliseconds: 3000));

    remove(context);
  }
}
