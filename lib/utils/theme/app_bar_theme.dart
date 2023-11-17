import 'package:budget_app/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../constants/sizes.dart';

class BudgetAppBarTheme {
  BudgetAppBarTheme._();

  static const light = AppBarTheme(
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: BudgetColors.primary,
    iconTheme: IconThemeData(color: BudgetColors.white, size: BudgetSizes.iconMd),
    actionsIconTheme: IconThemeData(color: BudgetColors.white, size: BudgetSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: BudgetColors.white),
  );
  static const dark = AppBarTheme(
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: BudgetColors.primary,
    iconTheme: IconThemeData(color:BudgetColors.white, size: BudgetSizes.iconMd),
    actionsIconTheme: IconThemeData(color: BudgetColors.white, size: BudgetSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: BudgetColors.white),
  );
}
