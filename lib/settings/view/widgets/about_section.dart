import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qruto_budget/shared/shared.dart';

import '../../../utils/theme/budget_theme.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0, bottom: 4.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('About',
                style: TextStyle(
                  fontSize: 44.sp,
                  color: BudgetTheme.isDarkMode(context)
                      ? Colors.white
                      : themeState.primaryColor[900],
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Card(
            child: ListTile(
              onTap: () => SharedFunctions.showWhatsNewSheet(context),
              leading: FaIcon(
                FontAwesomeIcons.bookOpen,
                color: BudgetTheme.isDarkMode(context)
                    ? Colors.white
                    : themeState.primaryColor[900],
                size: 36,
              ),
              title: Text('What\'s new',
                  style: Theme.of(context).textTheme.titleLarge!),
              subtitle: Text('Open bottom sheet'),
            ),
          ),
        ),
      ],
    );
  }
}
