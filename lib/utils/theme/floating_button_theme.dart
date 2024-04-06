import 'package:flutter/material.dart';

import '../utils.dart';

class BudgetFloatingButtonTheme {

  final AppColors seedColors;

  BudgetFloatingButtonTheme(this.seedColors);

  FloatingActionButtonThemeData get light =>
  FloatingActionButtonThemeData(
      backgroundColor: seedColors.secondaryColor,
      foregroundColor: Colors.white
  );

  FloatingActionButtonThemeData get dark =>
  FloatingActionButtonThemeData(
      backgroundColor: seedColors.secondaryColor,
      foregroundColor: seedColors.primaryColor[900]
  );
}
