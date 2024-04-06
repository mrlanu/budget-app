import 'package:budget_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class BudgetBottomNavigationBarTheme {

  BudgetBottomNavigationBarTheme({required this.color});

  final AppColors color;

  BottomNavigationBarThemeData get light => BottomNavigationBarThemeData(
    backgroundColor: color.primaryColor,
  );
  BottomNavigationBarThemeData get dark => BottomNavigationBarThemeData(
    backgroundColor: color.primaryColor[900],
  );
}
