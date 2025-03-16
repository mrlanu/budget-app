import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/shared.dart';
import '../home.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      UpdateChecker.checkIfUpdated(context);
    });
    Future.delayed(Duration.zero, () {
      if (kReleaseMode) {
        UpdateChecker.checkForUpdate(context);
      } else {
        print("Skipping update check in debug mode.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeMobilePage(navigationShell: widget.navigationShell);
  }
}
