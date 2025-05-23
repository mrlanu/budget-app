import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qruto_budget/charts/cubit/chart_cubit.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';

class IncludeCurrentMonthSwitch extends StatelessWidget {
  const IncludeCurrentMonthSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    final isInclude =
    context.select((ChartCubit cubit) => cubit.state.includeCurrentMonth);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Include current month', style: TextStyle(fontSize: 24.sp)),
          SizedBox(width: 10),
          Switch(
            activeColor: themeState.secondaryColor,
            thumbIcon: _thumbIcon,
            value: isInclude,
            onChanged: (bool value) {
              context
                  .read<ChartCubit>()
                  .switchMonth(value);
            },
          ),
        ],
      ),
    );
  }
}

final WidgetStateProperty<Icon?> _thumbIcon =
WidgetStateProperty.resolveWith<Icon?>(
      (Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return const Icon(Icons.check);
    }
    return const Icon(Icons.close);
  },
);
