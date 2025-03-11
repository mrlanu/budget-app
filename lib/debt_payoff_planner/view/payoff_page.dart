import 'package:budget_app/database/database.dart';
import 'package:budget_app/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:budget_app/debt_payoff_planner/repository/debts_repository.dart';
import 'package:budget_app/debt_payoff_planner/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/debt_cubit/debts_cubit.dart';
import '../debt_form/debt_form.dart';

class DebtPayoffPage extends StatelessWidget {

  DebtPayoffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
  create: (context) => DebtRepositoryDrift(database: context.read<AppDatabase>()),
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          DebtsCubit(debtsRepository: context.read<DebtRepositoryDrift>())..updateDebts(),
        ),
        BlocProvider(
          create: (context) => StrategyCubit(database: context.read<AppDatabase>()),
        ),
      ],
      child: DebtPayoffViewMobile(),
    ),
);
  }
}

class DebtPayoffViewMobile extends StatelessWidget {
  const DebtPayoffViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return _Body();
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Debt payoff planner'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  _openDialog(context: context);
                },
                icon: Icon(Icons.add)),
            StrategySelectButton()
          ],
        ),
        //bottomNavigationBar: DebtController(),
        body: SingleChildScrollView(
            child: Column(
              children: [
                DebtController(),
                DebtCarousel(
                    onEdit: (debt) =>
                        _openDialog(debt: debt, context: context)),
                DebtStrategy(),
              ],
            )),
      ),
    );
  }
}

void _openDialog({required BuildContext context, Debt? debt}) {
  showDialog<String>(
    context: context,
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
          DebtBloc(debtsRepository: context.read<DebtRepositoryDrift>())
            ..add(FormInitEvent(debt: debt)),
        ),
        BlocProvider.value(
          value: context.read<DebtsCubit>(),
        ),
      ],
      child: DebtDialog(),
    ),
  );
}

