import 'package:budget_app/debt_payoff_planner/view/widgets/strategy_select_button.dart';
import 'package:budget_app/debt_payoff_planner/view/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DebtPayoffPage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => DebtPayoffPage(),
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
        actions: [
          StrategySelectButton()
        ],
      ),
      bottomNavigationBar: DebtController(),
      body: SingleChildScrollView(
          child: Column(
            children: [
              CarouselWithIndicatorDemo(),
              PayoffSummary(),
              ReportTile(),
              ReportTile(),
              DebtFreeCongrats(),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
