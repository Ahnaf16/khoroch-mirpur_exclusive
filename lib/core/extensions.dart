import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khoroch/theme/theme.dart';
import 'package:khoroch/widgets/widgets.dart';
import 'package:routemaster/routemaster.dart';

extension ContextEx on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);

  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  Orientation get orientation => MediaQuery.of(this).orientation;

  ColorScheme get color => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  Brightness get getBright => theme.brightness;
  bool get isDark => getBright == Brightness.dark;
  bool get isLight => getBright == Brightness.light;

  void get pop => Navigator.pop(this);

  void get rPop => Routemaster.of(this).pop();

  NavigationResult pushTo(String route, {Map<String, String>? quarry}) {
    return Routemaster.of(this).push(route, queryParameters: quarry);
  }

  showSnack(String content) =>
      showSnackContent(Text(content, style: textTheme.bodyMedium));
  showError(String content) => showSnackContent(
        Text(
          content,
          style: textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        true,
      );

  showSnackContent(Widget content, [bool isError = false]) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: content,
          backgroundColor: isError
              ? AppTheme.errorColor.withOpacity(.7)
              : AppTheme.backgroundColor,
          elevation: 30,
          behavior: SnackBarBehavior.floating,
          clipBehavior: Clip.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  OverlayLoader get showOverLay => OverlayLoader(this);

  removeFocus() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

extension StringEx on String {
  int get asInt {
    return isEmpty ? 0 : int.parse(this);
  }

  double get asDouble {
    return isEmpty ? 0.0 : double.parse(this);
  }

  String showUntil(int end, [int start = 0]) {
    return length >= end ? '${substring(start, end)}...' : this;
  }

  bool get isEmail {
    final reg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return reg.hasMatch(this);
  }

  bool get isPhone {
    final reg = RegExp(r'(\+8801\d{9})|(01\d{9})');
    return reg.hasMatch(this);
  }

  String get toTitleCase {
    List<String> words = split(' ');

    String capitalizedText = ' ';

    for (int i = 0; i < words.length; i++) {
      capitalizedText += words[i][0].toUpperCase() + words[i].substring(1);
      if (i < words.length - 1) {
        capitalizedText += ' ';
      }
    }
    return capitalizedText;
  }
}

extension DateTimeFormat on DateTime {
  String formateDate([String pattern = 'dd-MM-yyyy\nhh:mm']) {
    return DateFormat(pattern).format(this);
  }
}

extension CurrencyConvert on int {
  String get toCurrency {
    return NumberFormat.currency(
      locale: 'en_BD',
      decimalDigits: 0,
      customPattern: '##,##,##,##,### tk',
    ).format(this);
  }
}
