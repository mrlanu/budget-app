import 'package:qruto_budget/shared/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/theme/cubit/theme_cubit.dart';

class CategoriesGrid extends StatelessWidget {
  final Function(int) onSelect;
  final int selectedIconCode;

  const CategoriesGrid(
      {super.key, this.selectedIconCode = -1, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
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
                        ? themeState.secondaryColor
                        : themeState.primaryColor[100],
                child: Center(
                    child: FaIcon(appIconsList[index].iconData,
                        color: themeState.primaryColor[900])),
              ),
            ),
          );
        });
  }
}
