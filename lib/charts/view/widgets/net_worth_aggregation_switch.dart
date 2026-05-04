import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qruto_budget/charts/cubit/net_worth_cubit.dart';
import 'package:qruto_budget/charts/repository/chart_repository.dart';

class NetWorthAggregationSwitch extends StatelessWidget {
  const NetWorthAggregationSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final aggregation =
        context.select((NetWorthCubit c) => c.state.aggregation);
    final loading = context.select(
      (NetWorthCubit c) =>
          c.state.status == NetWorthStatus.loading ||
          c.state.status == NetWorthStatus.initial,
    );
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SegmentedButton<NetWorthAggregation>(
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return isDark
              ? Colors.white.withValues(alpha: 0.08)
              : scheme.surfaceContainerHigh;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.onPrimary;
          }
          return isDark
              ? Colors.white.withValues(alpha: 0.65)
              : scheme.onSurface.withValues(alpha: 0.65);
        }),
      ),
      segments: const [
        ButtonSegment(
          value: NetWorthAggregation.monthly,
          label: Text('Month by month'),
        ),
        ButtonSegment(
          value: NetWorthAggregation.yearly,
          label: Text('Year by year'),
        ),
      ],
      selected: {aggregation},
      onSelectionChanged: loading
          ? null
          : (s) {
              if (s.isNotEmpty) {
                context.read<NetWorthCubit>().setAggregation(s.first);
              }
            },
    );
  }
}
