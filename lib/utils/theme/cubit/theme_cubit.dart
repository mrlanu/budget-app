import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../budget_theme.dart';

const List<MaterialColor> appAccentColors = [
  Colors.teal,
  Colors.indigo,
  Colors.pink,
  Colors.orange,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.blueGrey
];

class ThemeCubit extends HydratedCubit<AppColors> {
  ThemeCubit()
      : super((
          primaryColor: defaultPrimaryColor,
          secondaryColor: defaultSecondaryColor
        ));

  static const defaultPrimaryColor = Colors.teal;
  static const defaultSecondaryColor = Color(0xffFF9843);

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
      4278228616 => (primaryColor: appAccentColors[0], secondaryColor: Color(0xffFF9843)),
      4282339765 => (primaryColor: appAccentColors[1], secondaryColor: Color(0xffc0b15c)),
      4293467747 => (primaryColor: appAccentColors[2], secondaryColor: Color(0xff7e00a1)),
      4294940672 => (primaryColor: appAccentColors[3], secondaryColor: Color(0xff001ba1)),
      4283215696 => (primaryColor: appAccentColors[4], secondaryColor: Color(0xff7e00a1)),
      4294198070 => (primaryColor: appAccentColors[5], secondaryColor: Color(0xff7e00a1)),
      4288423856 => (primaryColor: appAccentColors[6], secondaryColor: Color(0xff7e00a1)),
      4284955319 => (primaryColor: appAccentColors[7], secondaryColor: Color(0xff7e00a1)),
      4284513675 => (primaryColor: appAccentColors[8], secondaryColor: Color(0xff000000)),
      _ => (primaryColor: Colors.grey, secondaryColor: Color(0xffa62633)),
    };
  }
}
