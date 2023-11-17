import 'package:budget_app/shared/models/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/colors.dart';

class CategoriesGrid extends StatelessWidget {
  final Function(int) onSelect;
  final int selectedIconCode;

  const CategoriesGrid(
      {super.key, this.selectedIconCode = -1, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        itemCount: appIconsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => onSelect(appIconsList[index].iconData.codePoint),
              child: CircleAvatar(
                backgroundColor:
                    selectedIconCode == appIconsList[index].iconData.codePoint
                        ? BudgetColors.accent
                        : BudgetColors.lightContainer,
                child: Center(
                    child: FaIcon(appIconsList[index].iconData,
                        color: BudgetColors.primary)),
              ),
            ),
          );
        });
  }
}
