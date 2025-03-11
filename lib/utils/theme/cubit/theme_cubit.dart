import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

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
    final (primaryColor, secondaryColor) = ThemeState.defineColors(color.toARGB32());
    emit(state.copyWith(
        primaryColor: primaryColor, secondaryColor: secondaryColor));
  }

  void updateMode(int mode) {
    emit(state.copyWith(mode: mode));
  }

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
return ThemeState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) {
    return state.toJson(state);
  }

}
