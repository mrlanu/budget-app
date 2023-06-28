import 'package:flutter/material.dart';

class DebtController extends StatelessWidget {
  const DebtController({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text('min'),
                        Text('\$ 5000.0 +',
                            style: Theme.of(context).textTheme.titleLarge)
                      ],
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
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
                        Text('= \$ 5000.0',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
