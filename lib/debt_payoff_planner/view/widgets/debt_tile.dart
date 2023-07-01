import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/debt.dart';

class DebtTile extends StatelessWidget {

  final Debt debtModel;
  final Function onEdit;

  const DebtTile({super.key, required this.debtModel, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.zero,
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.zero),
                color: scheme.tertiaryContainer,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(debtModel.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${debtModel.apr} % APR',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  ButtonBar(
                    children: [
                      IconButton.filled(
                          onPressed: () => onEdit(debtModel),
                          icon: const Icon(Icons.edit_note)),
                      IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.close)),
                    ],
                  )
                ],
              )),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${DateFormat('MM-dd-yyyy').format(debtModel.nextPaymentDue)}', style: Theme.of(context).textTheme.titleMedium),
                        Text('PAYMENT DUE', style: Theme.of(context).textTheme.bodySmall),
                        Expanded(child: Container()),
                        Text('--'),
                        Text('LAST PAYMENT', style: Theme.of(context).textTheme.bodySmall),
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$ ${debtModel.minimumPayment}', style: Theme.of(context).textTheme.titleMedium),
                        Text('MIN PAYMENT', style: Theme.of(context).textTheme.bodySmall),
                        Expanded(child: Container()),
                        Text('\$ ${debtModel.currentBalance}', style: Theme.of(context).textTheme.titleMedium),
                        Text('CURRENT BALANCE', style: Theme.of(context).textTheme.bodySmall),
                      ])
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.zero,
                  bottomRight: Radius.circular(10.0),
                  topLeft: Radius.zero,
                  bottomLeft: Radius.circular(10.0)),
              color: scheme.tertiaryContainer,
            ),
            child: Text('Completed: ', style: Theme.of(context).textTheme.titleMedium),)
        ],
      ),
    );
  }
}
