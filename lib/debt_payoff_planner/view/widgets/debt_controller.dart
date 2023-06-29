import 'package:flutter/material.dart';

class DebtController extends StatelessWidget {
  const DebtController({super.key});

  @override
  Widget build(BuildContext context) {
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
                Text('\$ 50.0 +',
                    style: Theme.of(context).textTheme.titleLarge)
              ],
            ),
            SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                style: Theme.of(context).textTheme.titleLarge,
                initialValue: '0.0',
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'extra'),
                onChanged: (value) {},
              ),
            ),
            SizedBox(width: 15),
            Column(
              children: [
                Text('total'),
                Text('= \$ 50.0',
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ],
        ));
  }
}
