import 'package:budget_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils.dart';

class BudgetTheme {
  BudgetTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    disabledColor: BudgetColors.grey,
    brightness: Brightness.light,
    primaryColor: BudgetColors.primary,
    scaffoldBackgroundColor: BudgetColors.light,
    textTheme: _buildLightTextTheme(),
    appBarTheme: BudgetAppBarTheme.light,
    floatingActionButtonTheme: BudgetFloatingButtonTheme.light,
    bottomNavigationBarTheme: BudgetBottomNavigationBarTheme.light,
    inputDecorationTheme: BudgetTextFormFieldTheme.light,
    drawerTheme: BudgetDrawerTheme.light,
    checkboxTheme: BudgetCheckboxTheme.lightCheckboxTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    disabledColor: BudgetColors.grey,
    brightness: Brightness.dark,
    primaryColor: BudgetColors.primary,
    scaffoldBackgroundColor: BudgetColors.dark,
    textTheme: _buildDarkTextTheme(),
    appBarTheme: BudgetAppBarTheme.dark,
    cardTheme: CardTheme(color: BudgetColors.darkerGrey),
    dialogTheme: DialogTheme(
      backgroundColor: BudgetColors.darkerGrey,
    ),
    floatingActionButtonTheme: BudgetFloatingButtonTheme.dark,
    bottomNavigationBarTheme: BudgetBottomNavigationBarTheme.dark,
    inputDecorationTheme: BudgetTextFormFieldTheme.dark,
    drawerTheme: BudgetDrawerTheme.dark,
  );

  static TextTheme _buildLightTextTheme() =>
      GoogleFonts.robotoCondensedTextTheme();

  static TextTheme _buildDarkTextTheme() =>
      GoogleFonts.robotoCondensedTextTheme().copyWith(
          bodySmall: TextStyle(color: BudgetColors.lightContainer),
          bodyLarge: TextStyle(color: BudgetColors.lightContainer),
          titleLarge: TextStyle(color: BudgetColors.lightContainer),
          titleMedium: TextStyle(color: BudgetColors.lightContainer),
          titleSmall: TextStyle(color: BudgetColors.lightContainer));

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
