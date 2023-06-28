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
      appBar: AppBar(
        title: Text('Debt payoff planner'),
        centerTitle: true,
        backgroundColor: scheme.primaryContainer,
      ),
      body: DebtController(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
