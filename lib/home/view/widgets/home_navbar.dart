import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:qruto_budget/utils/theme/budget_theme.dart';

import '../../home.dart';

class HomeNavBar extends StatelessWidget {
  const HomeNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return NavigationBar(
          selectedIndex: state.tab.index,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
            context.read<HomeCubit>().setTab(index);
          },
          elevation: 0,
          indicatorColor:
              BudgetTheme.isDarkMode(context) ? Colors.white38 : Colors.white38,
          destinations: [
            NavigationDestination(
              label: 'income',
              icon: FaIcon(
                color: Colors.white,
                FontAwesomeIcons.rightToBracket,
              ),
            ),
            NavigationDestination(
              label: 'expenses',
              icon: FaIcon(
                color: Colors.white,
                FontAwesomeIcons.rightFromBracket,
              ),
            ),
            NavigationDestination(
              label: 'accounts',
              icon: FaIcon(
                color: Colors.white,
                FontAwesomeIcons.house,
              ),
            ),
          ],
        );
      },
    );
  }
}
