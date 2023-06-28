import 'package:flutter/material.dart';

class DebtPayoffPage extends StatelessWidget {

  static Route<void> route(){
    return MaterialPageRoute(builder: (context) => DebtPayoffPage(),);
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
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Planner'),),
    );
  }
}

