import 'package:flutter/material.dart';

import 'material_theme.dart';

class AppTheme {
  AppTheme._();

  static final _materialTheme = MaterialTheme(
    Typography.material2021().black,
  );

  static ThemeData get light {
    final base = _materialTheme.light();

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),

      cardTheme: const CardThemeData(
        elevation: 2,
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            48,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final base = _materialTheme.dark();

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  static Color statusColor(
    String status,
    BuildContext context,
  ) {
    final cs = Theme.of(context).colorScheme;

    switch (status) {
      case 'pending':
        return Colors.orange.shade700;

      case 'preparing':
        return cs.primary;

      case 'ready':
        return Colors.green.shade700;

      case 'delivered':
        return cs.outline;

      default:
        return cs.outline;
    }
  }
}