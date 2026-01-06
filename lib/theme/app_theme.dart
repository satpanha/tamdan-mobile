import 'package:flutter/material.dart';

ThemeData getAppTheme() {
  final seed = Colors.blue;
  final colorScheme = ColorScheme.fromSeed(seedColor: seed);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      elevation: 1,
      iconTheme: IconThemeData(color: colorScheme.primary),
      titleTextStyle: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontSize: 16),
      titleSmall: TextStyle(fontSize: 14),
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );
}
