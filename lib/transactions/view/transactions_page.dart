import 'package:budget_app/categories/models/category.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  static const routeName = '/transactions';

  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category =
    ModalRoute.of(context)?.settings.arguments as Map<String, Category>;
    return Scaffold(
      appBar: AppBar(
        title: Text('${category['category']?.name}'),
      ),
      body: Center(
        child: Text('${category['category']?.id}'),
      ),
    );
  }
}
