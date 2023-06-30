import 'package:budget_app/debt_payoff_planner/cubits/debt_cubit/debt_cubit.dart';
import 'package:budget_app/debt_payoff_planner/cubits/debt_cubit/debt_cubit.dart';
import 'package:budget_app/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:budget_app/debt_payoff_planner/models/debt_strategy_report.dart';
import 'package:budget_app/debt_payoff_planner/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DebtStrategy extends StatelessWidget {
  const DebtStrategy({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DebtCubit, DebtState>(
      listener: (context, state) {
        context.read<StrategyCubit>().fetchStrategy();
      },
      child: BlocBuilder<StrategyCubit, StrategyState>(
        builder: (context, state) {
          return state is LoadedStrategyState
              ? Column(
                  children: [
                    PayoffSummary(debtPayoffStrategy: state.debtPayoffStrategy),
                    for (DebtStrategyReport report
                        in state.debtPayoffStrategy.reports)
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
