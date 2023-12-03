import 'package:flutter/material.dart';
import 'package:space_metro/src/core/theme/colors.dart';

class MetroTheme {
  static const _textColor = MetroPalette.black;
  static const _lineHeight = 1.0;
  static const _fontFamily = 'AlmendraSC';

  // font sizes
  static const double _buttonFontSize = 14;
  static const double _bodyTextFontSize = 16;
  static const double _h2HeaderFontSize = 24;
  static const double _h1HeaderFontSize = 32;

  // light text theme
  static const lightTextTheme = TextTheme(
    headlineMedium: TextStyle(
      color: _textColor,
      fontSize: _h1HeaderFontSize,
      fontWeight: FontWeight.w600,
      height: _lineHeight,
    ),
    headlineSmall: TextStyle(
      color: _textColor,
      fontSize: _h2HeaderFontSize,
      height: _lineHeight,
    ),
    bodyMedium: TextStyle(
      color: _textColor,
      fontSize: _bodyTextFontSize,
      fontWeight: FontWeight.w500,
      height: _lineHeight,
    ),
    bodySmall: TextStyle(
      color: _textColor,
      fontSize: _buttonFontSize,
      height: _lineHeight,
      fontWeight: FontWeight.w500,
    ),
  );

  // elevated button theme
  static final ElevatedButtonThemeData _lightElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: MetroPalette.primary,
      foregroundColor: MetroPalette.white,
      elevation: 0,
      fixedSize: const Size(double.infinity, 60),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(100.),
      // ),
    ),
  );

  static ThemeData light() => ThemeData(
        fontFamily: _fontFamily,
        textTheme: lightTextTheme,
        scaffoldBackgroundColor: MetroPalette.primary.withOpacity(0.25),
        colorScheme: ColorScheme.fromSeed(seedColor: MetroPalette.primary),
        elevatedButtonTheme: _lightElevatedButtonTheme,
      );
}
