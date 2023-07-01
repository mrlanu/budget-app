import 'package:budget_app/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/debt_cubit/debts_cubit.dart';

class DebtController extends StatefulWidget {
  const DebtController({super.key});

  @override
  State<DebtController> createState() => _DebtControllerState();
}

class _DebtControllerState extends State<DebtController> {
  late TextEditingController _textEditingController;
  double? total;
  double sumMinPayments = 0.0;

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
    final text = _textEditingController.text;
    try {
      final doubleText = double.parse(text);
      setState(() {
        total = doubleText + sumMinPayments;
      });
      final strategyCubit = context.read<StrategyCubit>();
      final state = strategyCubit.state as LoadedStrategyState;
      strategyCubit.fetchStrategy(
          extraPayment: doubleText.toString(), strategyName: state.strategy);
    } catch (e) {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DebtsCubit, DebtsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return BlocBuilder<DebtsCubit, DebtsState>(
          builder: (context, state) {
            sumMinPayments = state.debtList
                .fold(0.0, (prevValue, d) => prevValue + d.minimumPayment);
            return Container(
                color: Theme.of(context).colorScheme.primaryContainer,
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
                        Text('= \$ ${total ?? sumMinPayments}',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ],
                ));
          },
        );
      },
    );
  }
}
