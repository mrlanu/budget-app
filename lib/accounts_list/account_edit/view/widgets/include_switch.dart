import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/theme/cubit/theme_cubit.dart';
import '../../bloc/account_edit_bloc.dart';

class IncludeSwitch extends StatelessWidget {
  const IncludeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    final isIncludeInTotals =
        context.select((AccountEditBloc bloc) => bloc.state.isIncludeInTotals);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Include in totals', style: TextStyle(fontSize: 24.sp)),
        SizedBox(width: 10),
        Switch(
          activeColor: themeState.secondaryColor,
          thumbIcon: _thumbIcon,
          value: isIncludeInTotals,
          onChanged: (bool value) {
            context
                .read<AccountEditBloc>()
                .add(AccountIncludeInTotalsChanged(value: value));
          },
        ),
      ],
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
