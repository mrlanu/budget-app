import 'package:budget_app/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

/// Custom Class for Light & Dark Text Themes
class BudgetCheckboxTheme {
  BudgetCheckboxTheme(this.appColors); // To avoid creating instances

  final AppColors appColors;

  /// Customizable Light Text Theme
  CheckboxThemeData get lightCheckboxTheme => CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BudgetSizes.xs)),
    checkColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return BudgetColors.white;
      } else {
        return BudgetColors.black;
      }
    }),
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return appColors.secondaryColor;
      } else {
        return Colors.transparent;
      }
    }),
  );

  /// Customizable Dark Text Theme
  CheckboxThemeData get darkCheckboxTheme => CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BudgetSizes.xs)),
    checkColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return BudgetColors.white;
      } else {
        return BudgetColors.black;
      }
    }),
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return appColors.secondaryColor;
      } else {
        return Colors.transparent;
      }
    }),
  );
}
