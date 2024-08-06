import 'package:flutter/material.dart';

class GlobalThemeData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  //static final Color _darkFocusColor = Colors.white.withOpacity(0.12);
  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  //static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ColorScheme lightColorScheme = ColorScheme(
      primary: Colors.blue.shade900,
      onPrimary: Colors.white,
      secondary: Colors.grey.shade300,
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.grey.shade300,
      surface: Colors.blue.shade800,
      onSurface: Colors.grey.shade800,
      brightness: Brightness.light);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
        colorScheme: colorScheme,
        canvasColor: colorScheme.background,
        scaffoldBackgroundColor: colorScheme.background,
        highlightColor: Colors.transparent,
        focusColor: focusColor,
        appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor : Colors.blue.shade900,
            foregroundColor: Colors.white
            ));
  }
}
