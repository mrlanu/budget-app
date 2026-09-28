import 'package:qruto_budget/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
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
  late final TextEditingController _textEditingController;
  var _seeded = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    final extra = context.read<StrategyCubit>().state.extraPayment;
    _textEditingController.text = extra;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onChanged(BuildContext context) {
    setState(() {});
    context.read<StrategyCubit>()
      ..changeExtraPayment(_textEditingController.text)
      ..fetchStrategy();
  }

  double _parseString(String text) {
    return double.tryParse(text) ?? 0;
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
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 80,
          child: Row(
            children: [
              Column(
                children: [
                  const Text('min'),
                  Text(
                    '\$ $sumMinPayments +',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.titleLarge,
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'extra',
                  ),
                  onChanged: (_) => _onChanged(context),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                children: [
                  const Text('total'),
                  Text(
                    '= \$ $total',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
