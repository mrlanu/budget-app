import 'package:qruto_budget/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StrategySelectButton extends StatelessWidget {
  const StrategySelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: 'Snowball',
      tooltip: 'Choose strategy',
      onSelected: (strategy) {
        context.read<StrategyCubit>()
          ..changeStrategy(strategy)
          ..fetchStrategy();
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 'Snowball',
            child: Text('Snowball'),
          ),
          PopupMenuItem(
            value: 'Avalanche',
            child: Text('Avalanche'),
          ),
        ];
      },
      icon: const Icon(Icons.filter_2),
    );
  }
}
