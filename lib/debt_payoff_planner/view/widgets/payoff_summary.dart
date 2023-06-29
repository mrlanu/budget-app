import 'package:flutter/material.dart';

class PayoffSummary extends StatelessWidget {
  const PayoffSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('Feb 25 2024', style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                Text('DEBT FREE ON', style: textTheme.bodySmall),
              ],
            ),
            Column(
              children: [
                Text('20 months', style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                Text('DURATION', style: textTheme.bodySmall),
              ],
            ),
            Column(
              children: [
                Text('\$ 250.79', style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                Text('TOTAL INTEREST', style: textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
