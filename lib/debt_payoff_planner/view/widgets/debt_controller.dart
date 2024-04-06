import 'package:budget_app/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/theme/budget_theme.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../cubits/debt_cubit/debts_cubit.dart';

class DebtController extends StatefulWidget {
  const DebtController({super.key});

  @override
  State<DebtController> createState() => _DebtControllerState();
}

class _DebtControllerState extends State<DebtController> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onChanged(BuildContext context) {
    final doubleText = _parseString(_textEditingController.text);
    setState(() {});
    final strategyCubit = context.read<StrategyCubit>();
    final state = strategyCubit.state;
    final isLoadedState = state is LoadedStrategyState;
    strategyCubit.fetchStrategy(
        extraPayment: doubleText.toString(),
        strategyName: isLoadedState ? state.strategy : 'snowball');
  }

  double _parseString(String text) {
    double result;
    try {
      result = double.parse(text);
    } catch (e) {
      result = 0;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebtsCubit, DebtsState>(
      builder: (context, state) {
        final themeState = context.read<ThemeCubit>().state;
        final sumMinPayments = state.debtList
            .fold(0.0, (prevValue, d) => prevValue + d.minimumPayment);
        final total =
            sumMinPayments + _parseString(_textEditingController.text);
        return Container(
            color: BudgetTheme.isDarkMode(context)
                ? themeState.primaryColor
                : themeState.primaryColor[200],
            padding: EdgeInsets.all(15),
            width: double.infinity,
            height: 80,
            child: Row(
              children: [
                Column(
                  children: [
                    Text('min'),
                    Text('\$ ${sumMinPayments} +',
                        style: Theme.of(context).textTheme.titleLarge)
                  ],
                ),
                SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.titleLarge,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'extra'),
                    onChanged: (_) => _onChanged(context),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  children: [
                    Text('total'),
                    Text('= \$ $total',
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ],
            ));
      },
    );
  }
}
