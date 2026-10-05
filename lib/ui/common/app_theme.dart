import 'package:flutter/material.dart';
import 'package:supabase_practice/ui/common/app_colors.dart';

final BorderRadius kRadiusMedium = BorderRadius.circular(14);

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: kcPrimaryColor,
    primary: kcPrimaryColor,
    secondary: kcSecondaryColor,
    error: kcErrorColor,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: kcSurfaceColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: kcDarkGreyColor,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIconColor: kcMediumGrey,
      suffixIconColor: kcMediumGrey,
      labelStyle: const TextStyle(color: kcMediumGrey),
      border: OutlineInputBorder(
        borderRadius: kRadiusMedium,
        borderSide: const BorderSide(color: kcVeryLightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: kRadiusMedium,
        borderSide: const BorderSide(color: kcVeryLightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: kRadiusMedium,
        borderSide: const BorderSide(color: kcPrimaryColor, width: 1.6),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kcPrimaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: kRadiusMedium),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kcPrimaryColor,
        minimumSize: const Size.fromHeight(50),
        side: const BorderSide(color: kcPrimaryColor),
        shape: RoundedRectangleBorder(borderRadius: kRadiusMedium),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kcPrimaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
  );
}
