import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFFFAEE7F),
  primaryColorLight: const Color(0xF2FFB2EB),
  primaryColor: const Color(0xFF266B01),
  colorScheme: const ColorScheme.light(secondary: Color(0xFF266B01)),
  scaffoldBackgroundColor: Color.fromRGBO(17, 17, 31, 1.0),
  inputDecorationTheme: InputDecorationTheme(
    focusColor: Colors.lime,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
