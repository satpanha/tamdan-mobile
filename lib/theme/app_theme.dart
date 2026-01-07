import 'package:flutter/material.dart';

ThemeData getAppTheme() {
  final seed = const Color(0xFF1E88E5);
  final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,

    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      titleTextStyle: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
      centerTitle: false,
      toolbarHeight: kToolbarHeight + 4,
    ),

    cardTheme: CardThemeData(
      color: colorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
    ),

    dividerTheme: DividerThemeData(color: colorScheme.onSurface.withAlpha((0.08 * 255).round()), thickness: 1, space: 20),

    textTheme: TextTheme(
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
      bodyMedium: TextStyle(fontSize: 14, color: colorScheme.onSurface),
      bodySmall: TextStyle(fontSize: 13, color: colorScheme.onSurface.withAlpha((0.8 * 255).round())),
    ),
  );
} 
