import 'package:qruto_budget/constants/colors.dart';
import 'package:flutter/material.dart';

class BudgetDrawerTheme {
  BudgetDrawerTheme._();

  static const light = DrawerThemeData(backgroundColor: BudgetColors.light);
  static const dark = DrawerThemeData(
      backgroundColor: BudgetColors.dark, surfaceTintColor: Colors.white);
}
