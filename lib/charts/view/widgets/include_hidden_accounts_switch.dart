import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qruto_budget/charts/cubit/net_worth_cubit.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';

/// Accounts with “include in total” off are excluded from net worth unless this is on.
class IncludeHiddenAccountsSwitch extends StatelessWidget {
  const IncludeHiddenAccountsSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    final isHiddenIncluded = context.select(
      (NetWorthCubit c) => c.state.includeHiddenAccounts,
    );
    final loading = context.select(
      (NetWorthCubit c) =>
          c.state.status == NetWorthStatus.loading ||
          c.state.status == NetWorthStatus.initial,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Include hidden accounts',
            style: TextStyle(fontSize: 24.sp),
          ),
          SizedBox(width: 10),
          Switch(
            activeThumbColor: themeState.secondaryColor,
            thumbIcon: _thumbIcon,
            value: isHiddenIncluded,
            onChanged: loading
                ? null
                : (value) =>
                    context.read<NetWorthCubit>().setIncludeHiddenAccounts(value),
          ),
        ],
      ),
    );
  }
}

final WidgetStateProperty<Icon?> _thumbIcon =
    WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
  if (states.contains(WidgetState.selected)) {
    return const Icon(Icons.check);
  }
  return const Icon(Icons.close);
});
