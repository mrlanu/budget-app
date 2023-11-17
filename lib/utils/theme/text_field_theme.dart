import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class BudgetTextFormFieldTheme {
  BudgetTextFormFieldTheme._();

  static InputDecorationTheme light = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: BudgetColors.accent,
    suffixIconColor: BudgetColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: BudgetSizes.fontSizeMd, color: BudgetColors.black),
    hintStyle: const TextStyle().copyWith(fontSize: BudgetSizes.fontSizeSm, color: BudgetColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: BudgetColors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BudgetSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BudgetColors.accent),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BudgetSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BudgetColors.primary),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BudgetSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BudgetColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BudgetSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BudgetColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BudgetSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: BudgetColors.warning),
    ),
  );

  static InputDecorationTheme dark = InputDecorationTheme(

    errorMaxLines: 2,
    prefixIconColor: BudgetColors.accent,
    suffixIconColor: BudgetColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: BudgetSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: BudgetSizes.fontSizeMd, color: BudgetColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: BudgetSizes.fontSizeSm, color: BudgetColors.white),
    floatingLabelStyle: const TextStyle().copyWith(color: BudgetColors.white.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BudgetSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BudgetColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BudgetSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BudgetColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BudgetSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BudgetColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BudgetSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: BudgetColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(BudgetSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: BudgetColors.warning),
    ),
  );
}
