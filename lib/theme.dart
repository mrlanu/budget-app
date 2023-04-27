import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF000000),
  primaryColorLight: const Color(0xF2000000),
  primaryColor: const Color(0xFF266B01),
  colorScheme: const ColorScheme.light(secondary: Color(0xFF266B01)),
  scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
  inputDecorationTheme: InputDecorationTheme(
    focusColor: Colors.orange,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
