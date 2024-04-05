import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

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

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(ThemeState());

  void updateTheme(MaterialColor color) {
    final (primaryColor, secondaryColor) = _defineColors(color.value);
    emit(state.copyWith(
        primaryColor: primaryColor, secondaryColor: secondaryColor));
  }

  void updateMode(int mode) {
    emit(state.copyWith(mode: mode));
  }

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
    final color = Color(int.parse(json['color'] as String));
    final mode = int.parse(json['mode']);
    final (primaryColor, secondaryColor) = _defineColors(color.value);
    return ThemeState(
        primaryColor: primaryColor, secondaryColor: secondaryColor, mode: mode);
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) {
    return <String, dynamic>{
      'color': '${state.primaryColor.value}',
      'mode': state.mode
    };
  }

  (MaterialColor, Color) _defineColors(int value) {
    return switch (value) {
      4278228616 => (appAccentColors[0], Color(0xffFF9843)),
      4282339765 => (appAccentColors[1], Color(0xffc0b15c)),
      4293467747 => (appAccentColors[2], Color(0xff7e00a1)),
      4294940672 => (appAccentColors[3], Color(0xff001ba1)),
      4283215696 => (appAccentColors[4], Color(0xff7e00a1)),
      4294198070 => (appAccentColors[5], Color(0xff7e00a1)),
      4288423856 => (appAccentColors[6], Color(0xff7e00a1)),
      4284955319 => (appAccentColors[7], Color(0xff7e00a1)),
      4284513675 => (appAccentColors[8], Color(0xff000000)),
      _ => (Colors.grey, Color(0xffa62633)),
    };
  }
}
