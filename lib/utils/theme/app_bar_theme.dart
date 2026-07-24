import 'package:qruto_budget/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/sizes.dart';

class BudgetAppBarTheme {
  BudgetAppBarTheme(this.seedColor);

  final AppColors seedColor;

  static const _overlayStyle = SystemUiOverlayStyle(
    statusBarColor: Color(0x00000000),
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  AppBarTheme get light => AppBarTheme(
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: seedColor.primaryColor.shade400,
        systemOverlayStyle: _overlayStyle,
        iconTheme:
            IconThemeData(color: Colors.white, size: BudgetSizes.iconMd),
        actionsIconTheme:
            IconThemeData(color: Colors.white, size: BudgetSizes.iconMd),
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );

  AppBarTheme get dark => AppBarTheme(
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: seedColor.primaryColor.shade900,
        systemOverlayStyle: _overlayStyle,
        iconTheme:
            IconThemeData(color: Colors.white, size: BudgetSizes.iconMd),
        actionsIconTheme:
            IconThemeData(color: Colors.white, size: BudgetSizes.iconMd),
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
}
