import 'package:budget_app/debt_payoff_planner/cubits/debt_cubit/debts_cubit.dart';
import 'package:budget_app/debt_payoff_planner/cubits/debt_cubit/debts_cubit.dart';
import 'package:budget_app/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:budget_app/debt_payoff_planner/models/debt_strategy_report.dart';
import 'package:budget_app/debt_payoff_planner/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DebtStrategy extends StatelessWidget {
  const DebtStrategy({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DebtsCubit, DebtsState>(
      listener: (context, state) {
        final strategyCubit = context.read<StrategyCubit>();
        final state = strategyCubit.state;
        final isStateLoaded = state is LoadedStrategyState;
        strategyCubit.fetchStrategy(
            extraPayment: isStateLoaded ? state.extraPayment : '0',
            strategyName: isStateLoaded ? state.strategy : 'snowball');
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
