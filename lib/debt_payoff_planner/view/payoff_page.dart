import 'package:budget_app/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:budget_app/debt_payoff_planner/repository/debts_repository.dart';
import 'package:budget_app/debt_payoff_planner/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/debt_cubit/debts_cubit.dart';
import '../debt_form/debt_form.dart';
import '../models/models.dart';

class DebtPayoffPage extends StatelessWidget {
  static Route<void> route() {
    final repository = DebtRepositoryImpl();
    return MaterialPageRoute(
        builder: (context) => RepositoryProvider(
              create: (context) => repository,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        DebtsCubit(debtsRepository: repository)..updateDebts(),
                  ),
                  BlocProvider(
                    create: (context) => StrategyCubit(),
                  ),
                ],
                child: DebtPayoffPage(),
              ),
            ));
  }

  DebtPayoffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DebtPayoffView();
  }
}

class DebtPayoffView extends StatelessWidget {
  const DebtPayoffView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        title: Text('Debt payoff planner'),
        centerTitle: true,
        backgroundColor: scheme.primaryContainer,
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
              onEdit: (debt) => _openDialog(debt: debt, context: context)),
          DebtStrategy(),
        ],
      )),
    );
  }

  void _openDialog({required BuildContext context, Debt? debt}) {
    showDialog<String>(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                DebtBloc(debtsRepository: context.read<DebtRepositoryImpl>())
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
}
