import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1F1F1F)),
  cardColor: const Color(0xFF1E1E1E),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.tealAccent,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.tealAccent,
    secondary: Colors.tealAccent,
  ),
);
