import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static BoxDecoration get neuDecoration {
    return BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          blurRadius: 15,
          color: Colors.grey.shade500,
          offset: const Offset(4, 4),
        ),
        const BoxShadow(
          blurRadius: 15,
          color: Colors.white,
          offset: Offset(-4, -4),
        ),
      ],
    );
  }

  static final Color defContentColor = Colors.grey.shade600;
  static final Color backgroundColor = Colors.grey.shade300;
  static final Color successColor = Colors.green.shade300;
  static final Color errorColor = Colors.red.shade300;

  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      titleTextStyle: textTheme().titleMedium?.copyWith(letterSpacing: 3),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    iconTheme: IconThemeData(color: defContentColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      border: InputBorder.none,
      labelStyle: textTheme().labelLarge,
      prefixIconColor: Colors.grey.shade500,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: defContentColor,
      linearTrackColor: backgroundColor,
      circularTrackColor: backgroundColor,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      showDragHandle: true,
      modalBarrierColor: Colors.grey.withOpacity(.8),
      elevation: 30,
      backgroundColor: AppTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    ),
    textTheme: textTheme(),
  );

  static TextTheme textTheme() {
    return TextTheme(
      headlineMedium: GoogleFonts.rubik(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: defContentColor,
      ),
      headlineSmall: GoogleFonts.rubik(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: defContentColor,
      ),
      titleLarge: GoogleFonts.rubik(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: defContentColor,
      ),
      titleMedium: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: defContentColor,
      ),
      titleSmall: GoogleFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: defContentColor,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: defContentColor,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: defContentColor,
      ),
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
        color: defContentColor,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: defContentColor,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        color: defContentColor,
      ),
    );
  }
}
