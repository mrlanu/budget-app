import 'package:budget_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils.dart';

typedef AppColors = ({MaterialColor primaryColor, Color secondaryColor});

class BudgetTheme {
  BudgetTheme({required this.seedColors});

  final AppColors seedColors;

  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        disabledColor: BudgetColors.grey,
        brightness: Brightness.light,
        colorSchemeSeed: seedColors.primaryColor,
        scaffoldBackgroundColor: seedColors.primaryColor.shade50,
        textTheme: _buildLightTextTheme(),
        appBarTheme: BudgetAppBarTheme(seedColors).light,
        floatingActionButtonTheme: BudgetFloatingButtonTheme(seedColors).light,
        bottomNavigationBarTheme:
            BudgetBottomNavigationBarTheme(color: seedColors).light,
        drawerTheme: BudgetDrawerTheme.light,
        checkboxTheme: BudgetCheckboxTheme(seedColors).lightCheckboxTheme,
        cardColor: seedColors.primaryColor.shade100,
        splashColor: seedColors.primaryColor[200],
        highlightColor: Colors.transparent,
      );

  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        disabledColor: BudgetColors.grey,
        brightness: Brightness.dark,
        colorSchemeSeed: seedColors.primaryColor,
        scaffoldBackgroundColor: Color(0xFF272727),
        textTheme: _buildDarkTextTheme(),
        appBarTheme: BudgetAppBarTheme(seedColors).dark,
        cardTheme: CardTheme(color: BudgetColors.darkerGrey),
        dialogTheme: DialogTheme(
          backgroundColor: BudgetColors.darkerGrey,
        ),
        floatingActionButtonTheme: BudgetFloatingButtonTheme(seedColors).dark,
        bottomNavigationBarTheme:
            BudgetBottomNavigationBarTheme(color: seedColors).dark,
        inputDecorationTheme: BudgetTextFormFieldTheme.dark,
        drawerTheme: BudgetDrawerTheme.dark,
        splashColor: Colors.transparent,
        highlightColor: seedColors.primaryColor[200],
      );

  static TextTheme _buildLightTextTheme() =>
      GoogleFonts.interTextTheme();

  static TextTheme _buildDarkTextTheme() =>
      GoogleFonts.interTextTheme().copyWith(
          bodySmall: TextStyle(color: BudgetColors.lightContainer),
          bodyLarge: TextStyle(color: BudgetColors.lightContainer),
          titleLarge: TextStyle(color: BudgetColors.lightContainer),
          titleMedium: TextStyle(color: BudgetColors.lightContainer),
          titleSmall: TextStyle(color: BudgetColors.lightContainer));

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
