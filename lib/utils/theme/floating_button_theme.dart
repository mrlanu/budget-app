import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class BudgetFloatingButtonTheme {
  BudgetFloatingButtonTheme._();

  static const FloatingActionButtonThemeData light =
      FloatingActionButtonThemeData(
        backgroundColor: BudgetColors.accent,
          foregroundColor: BudgetColors.dark
      );

  static const FloatingActionButtonThemeData dark =
  FloatingActionButtonThemeData(
    backgroundColor: BudgetColors.accentDark,
    foregroundColor: BudgetColors.light
  );
}
