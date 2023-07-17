// defined in app.dart
import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:flutter/cupertino.dart';

late double w;
late double h;

bool isDisplayDesktop(BuildContext context) =>
        getWindowType(context) >= AdaptiveWindowType.medium;
