import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../budget_theme.dart';

class ThemeCubit extends HydratedCubit<AppColors> {
  ThemeCubit()
      : super((
          primaryColor: defaultPrimaryColor,
          secondaryColor: defaultSecondaryColor
        ));

  static const defaultPrimaryColor = Colors.teal;
  static const defaultSecondaryColor = Color(0xFFCD4C80);

  void updateTheme(MaterialColor primaryColor) {
    emit(_defineColors(primaryColor.value));
  }

  @override
  AppColors fromJson(Map<String, dynamic> json) {
    final color = Color(int.parse(json['color'] as String));
    print('Value: ${color.value}');
    return _defineColors(color.value);
  }

  @override
  Map<String, dynamic> toJson(AppColors state) {
    return <String, dynamic>{'color': '${state.primaryColor.value}'};
  }

  AppColors _defineColors(int value){
    return switch (value) {
      4278228616 => (primaryColor: Colors.teal, secondaryColor: Color(0xffFF9843)),
      4282339765 => (primaryColor: Colors.indigo, secondaryColor: Color(0xffc0b15c)),
      4293467747 => (primaryColor: Colors.pink, secondaryColor: Color(0xff7e00a1)),
      _ => (primaryColor: Colors.grey, secondaryColor: Color(0xffa62633)),
    };
  }
}
