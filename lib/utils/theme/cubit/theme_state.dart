part of 'theme_cubit.dart';

@JsonSerializable()
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

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    final color = Color(int.parse(json['color'] as String));
    final mode = json['mode'];
    final (primaryColor, secondaryColor) = defineColors(color.toARGB32());
    return ThemeState(
        primaryColor: primaryColor, secondaryColor: secondaryColor, mode: mode);
  }

  Map<String, dynamic> toJson(ThemeState state) {
    return <String, dynamic>{
      'color': '${state.primaryColor.toARGB32()}',
      'mode': state.mode
    };
  }

  static (MaterialColor, Color) defineColors(int value) {
    return switch (value) {
      4278228616 => (appAccentColors[0], Color(0xffFF9843)),
      4282339765 => (appAccentColors[1], Color(0xffc0b15c)),
      4293467747 => (appAccentColors[2], Color(0xff3F51B5)),
      4294940672 => (appAccentColors[3], Color(0xff001ba1)),
      4283215696 => (appAccentColors[4], Color(0xff7e00a1)),
      4294198070 => (appAccentColors[5], Color(0xff7e00a1)),
      4288423856 => (appAccentColors[6], Color(0xffFF80AB)),
      4284955319 => (appAccentColors[7], Color(0xffFF80AB)),
      4284513675 => (appAccentColors[8], Color(0xff000000)),
      _ => (Colors.grey, Color(0xffa62633)),
    };
  }

  List<MaterialColor> appAccentColors2 = [
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

  @override
  List<Object> get props => [primaryColor, secondaryColor, mode];
}
