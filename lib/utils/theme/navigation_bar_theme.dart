import 'package:qruto_budget/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class BudgetNavigationBarTheme {

  BudgetNavigationBarTheme({required this.color});

  final AppColors color;

  NavigationBarThemeData get light => NavigationBarThemeData(
    backgroundColor: color.primaryColor,
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
  NavigationBarThemeData get dark => NavigationBarThemeData(
    backgroundColor: color.primaryColor[900],
  );
}
