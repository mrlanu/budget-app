import 'package:qruto_budget/utils/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../constants/sizes.dart';

class BudgetAppBarTheme {
  BudgetAppBarTheme(this.seedColor);

  final AppColors seedColor;

 AppBarTheme get light => AppBarTheme(
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: seedColor.primaryColor.shade400,
    iconTheme: IconThemeData(color:Colors.white, size: BudgetSizes.iconMd),
    actionsIconTheme: IconThemeData(color:Colors.white, size: BudgetSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color:Colors.white,),
  );
  AppBarTheme get dark => AppBarTheme(
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: seedColor.primaryColor.shade900,
    iconTheme: IconThemeData(color:Colors.white, size: BudgetSizes.iconMd),
    actionsIconTheme: IconThemeData(color:Colors.white, size: BudgetSizes.iconMd),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color:Colors.white,),
  );
}
