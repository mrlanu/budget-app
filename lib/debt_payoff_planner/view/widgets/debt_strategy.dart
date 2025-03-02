import 'package:budget_app/debt_payoff_planner/view/widgets/payoff_summary.dart';
import 'package:budget_app/debt_payoff_planner/view/widgets/report_tile.dart';
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
        context.read<StrategyCubit>().fetchStrategy();
      },
      child: BlocBuilder<StrategyCubit, StrategyState>(
        builder: (context, state) {
          return state.status == StrategyStateStatus.success
              ? Column(
                  children: [
                    PayoffSummary(debtPayoffStrategy: state.debtPayoffStrategy!),
                    for (DebtStrategyReport report
                        in state.debtPayoffStrategy!.reports)
                      ReportTile(report: report),
                    DebtFreeCongrats(),
                  ],
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
