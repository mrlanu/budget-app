import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/budget_drawer.dart';
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      BackgroundWorker.checkIfUpdated(context);
      if (kReleaseMode) {
        BackgroundWorker.checkForUpdate(context);
      } else {
        print("Skipping update check in debug mode.");
      }
      BackgroundWorker.checkLastAutoBackup(context);
    });
  }

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed()
              ? const SizedBox()
              : BudgetDrawer(
                  onDrawer: _toggleDrawer,
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      HomeMobilePage(
        navigationShell: widget.navigationShell,
        onDrawer: _toggleDrawer,
      ),
      _buildDrawer(),
    ]));
  }
}
