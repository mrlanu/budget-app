import 'package:budget_app/debt_payoff_planner/cubits/strategy_cubit/strategy_cubit.dart';
import 'package:budget_app/debt_payoff_planner/repository/debts_repository.dart';
import 'package:budget_app/debt_payoff_planner/view/widgets/strategy_select_button.dart';
import 'package:budget_app/debt_payoff_planner/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/debt_cubit/debt_cubit.dart';

class DebtPayoffPage extends StatelessWidget {
  static Route<void> route() {
    final _repository = DebtRepositoryImpl();
    return MaterialPageRoute(
      builder: (context) => RepositoryProvider(
        create: (context) => _repository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  DebtCubit(debtsRepository: _repository)..initRequested(),
            ),
            BlocProvider(
              create: (context) => StrategyCubit(),
            ),
          ],
          child: DebtPayoffPage(),
        ),
      ),
    );
  }

  const DebtPayoffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DebtPayoffView();
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
        actions: [StrategySelectButton()],
      ),
      //bottomNavigationBar: DebtController(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          DebtController(),
          DebtCarousel(),
          DebtStrategy(),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
