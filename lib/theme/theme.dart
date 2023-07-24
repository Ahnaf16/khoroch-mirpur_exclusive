import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khoroch/core/core.dart';

class AppTheme {
  static BoxDecoration decoration(
    BuildContext context, {
    bool useRound = false,
  }) {
    return useRound
        ? _roundedDecoration(context.isDark)
        : _neuDecoration(context.isDark);
  }

  static BoxDecoration _roundedDecoration(bool isDark) {
    return BoxDecoration(
      color: mainColor,
      shape: BoxShape.circle,
      boxShadow: _boxShadows(isDark),
    );
  }

  static BoxDecoration _neuDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? mainColorDark : mainColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: _boxShadows(isDark),
    );
  }

  static _boxShadows(bool isDark) => [
        BoxShadow(
          spreadRadius: 1,
          blurRadius: 15,
          color: isDark ? Colors.black : Colors.grey.shade500,
          offset: const Offset(4, 4),
        ),
        BoxShadow(
          spreadRadius: 1,
          blurRadius: 15,
          color: isDark ? Colors.grey.shade800 : Colors.white,
          offset: const Offset(-5, -5),
        ),
      ];

  static final Color foregroundColor = Colors.grey.shade600;

  static final Color mainColor = Colors.grey.shade300;
  static final Color mainColorDark = Colors.grey.shade900;

  static final Color successColor = Colors.green.shade300;
  static final Color errorColor = Colors.red.shade300;

  static ThemeData get theme => _themeData(false);
  static ThemeData get darkTheme => _themeData(true);

  static ThemeData _themeData(bool isDark) {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDark ? mainColorDark : mainColor,
      primaryColor: foregroundColor,
      appBarTheme: AppBarTheme(
        titleTextStyle: textTheme().titleMedium?.copyWith(letterSpacing: 3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: foregroundColor),
        elevation: 0,
      ),
      iconTheme: IconThemeData(color: foregroundColor),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        border: InputBorder.none,
        labelStyle: textTheme().labelLarge,
        prefixIconColor: Colors.grey.shade500,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: foregroundColor,
        linearTrackColor: mainColor,
        circularTrackColor: mainColor,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        // modalBarrierColor: Colors.grey.withOpacity(.8),
        elevation: 30,
        backgroundColor: isDark ? mainColorDark : mainColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor:
              MaterialStateColor.resolveWith((states) => foregroundColor),
        ),
      ),
      textTheme: textTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: foregroundColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  static TextTheme textTheme() {
    return TextTheme(
      headlineMedium: GoogleFonts.rubik(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: foregroundColor,
      ),
      headlineSmall: GoogleFonts.rubik(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: foregroundColor,
      ),
      titleLarge: GoogleFonts.rubik(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: foregroundColor,
      ),
      titleMedium: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: foregroundColor,
      ),
      titleSmall: GoogleFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: foregroundColor,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: foregroundColor,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: foregroundColor,
      ),
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
        color: foregroundColor,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: foregroundColor,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        color: foregroundColor,
      ),
    );
  }
}
