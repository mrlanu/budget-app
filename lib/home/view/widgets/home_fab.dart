import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../home.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({super.key, required this.selectedTab});

  final HomeTab selectedTab;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        switch (selectedTab) {
          case HomeTab.expenses:
            context.push('/transaction/?typeIndex=0');
          case HomeTab.income:
            context.push('/transaction/?typeIndex=1');
          case HomeTab.accounts:
            context.push('/transfer');
        }
        ;
      },
      child: const Icon(
        Icons.add,
      ),
    );
  }
}
