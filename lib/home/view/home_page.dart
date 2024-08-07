import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return HomeMobilePage(navigationShell: navigationShell);
  }
}
