import 'package:qruto_budget/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StrategySelectButton extends StatelessWidget {
  const StrategySelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StrategyCubit, StrategyState>(
      buildWhen: (previous, current) => previous.strategy != current.strategy,
      builder: (context, state) {
        return PopupMenuButton<String>(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          initialValue: state.strategy,
          tooltip: 'Strategy: ${state.strategy}',
          onSelected: (strategy) {
            context.read<StrategyCubit>()
              ..changeStrategy(strategy)
              ..fetchStrategy();
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: StrategyState.snowball,
                child: Text('Snowball'),
              ),
              PopupMenuItem(
                value: StrategyState.avalanche,
                child: Text('Avalanche'),
              ),
            ];
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.strategy,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        );
      },
    );
  }
}
