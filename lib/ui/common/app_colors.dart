import 'package:flutter/material.dart';

const Color kcPrimaryColor = Color(0xFF6C3CE9);
const Color kcPrimaryColorDark = Color(0xFF300151);
const Color kcSecondaryColor = Color(0xFF3ECF8E); // Supabase green accent
const Color kcDarkGreyColor = Color(0xFF1A1B1E);
const Color kcMediumGrey = Color(0xFF474A54);
const Color kcLightGrey = Color.fromARGB(255, 187, 187, 187);
const Color kcVeryLightGrey = Color(0xFFE3E3E3);
const Color kcSurfaceColor = Color(0xFFF6F5FB);
const Color kcErrorColor = Color(0xFFE5484D);
const Color kcBackgroundColor = kcDarkGreyColor;

const LinearGradient kgPrimaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kcPrimaryColor, kcPrimaryColorDark],
);
