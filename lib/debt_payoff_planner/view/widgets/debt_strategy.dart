import 'package:qruto_budget/debt_payoff_planner/view/widgets/payoff_summary.dart';
import 'package:qruto_budget/debt_payoff_planner/view/widgets/report_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/debt_cubit/debts_cubit.dart';
import '../../cubits/strategy_cubit/strategy_cubit.dart';
import 'debt_free_congrats.dart';

class DebtStrategy extends StatelessWidget {
  const DebtStrategy({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DebtsCubit, DebtsState>(
      listener: (context, state) {
        if (state.status == DebtsStatus.success) {
          context.read<StrategyCubit>().fetchStrategy();
        }
      },
      child: BlocBuilder<DebtsCubit, DebtsState>(
        builder: (context, debtsState) {
          if (debtsState.debtList.isEmpty) {
            return const SizedBox.shrink();
          }

          return BlocBuilder<StrategyCubit, StrategyState>(
            builder: (context, state) {
              if (state.status == StrategyStateStatus.loading) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state.status == StrategyStateStatus.failure) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        state.errorMessage ?? 'Could not calculate strategy',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }

              if (state.status != StrategyStateStatus.success ||
                  state.debtPayoffStrategy == null) {
                return const SizedBox.shrink();
              }

              final strategy = state.debtPayoffStrategy!;
              return Column(
                children: [
                  if (!debtsState.isDebtFree) ...[
                    PayoffSummary(debtPayoffStrategy: strategy),
                    for (final report in strategy.reports)
                      ReportTile(report: report),
                  ],
                  if (debtsState.isDebtFree) const DebtFreeCongrats(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
