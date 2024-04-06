part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  ThemeState(
      {this.primaryColor = Colors.teal,
      this.secondaryColor = const Color(0xffFF9843),
      this.mode = 0});

  final MaterialColor primaryColor;
  final Color secondaryColor;
  final int mode;

  ThemeState copyWith({
    MaterialColor? primaryColor,
    Color? secondaryColor,
    int? mode,
  }) {
    return ThemeState(
        primaryColor: primaryColor ?? this.primaryColor,
        secondaryColor: secondaryColor ?? this.secondaryColor,
        mode: mode ?? this.mode);
  }

  @override
  List<Object> get props => [primaryColor, secondaryColor, mode];
}
