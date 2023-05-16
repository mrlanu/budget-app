import 'package:budget_app/transactions/transaction/view/transaction_form.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  static const routeName = '/transaction';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new transaction'),
      ),
      body: TransactionForm(),
    );
  }
}
