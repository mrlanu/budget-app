import 'package:flutter/material.dart';

class ReportTile extends StatelessWidget {
  const ReportTile({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 15),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 35,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.zero,
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.zero),
                color: scheme.tertiaryContainer
              ),
              child: Text('DURATION 5 MONTHS',
                  style: Theme.of(context).textTheme.titleSmall)),
          Container(
            height: 45,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                      Text('Capital One', style: Theme.of(context).textTheme.titleMedium),
                      Text('\$ 190', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          true ? Container(
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.zero,
                  bottomRight: Radius.circular(10.0),
                  topLeft: Radius.zero,
                  bottomLeft: Radius.circular(10.0)),
              color: Color.fromRGBO(231, 231, 231, 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AND MIN PAYMENT FOR:', style: Theme.of(context).textTheme.bodySmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Car', style: Theme.of(context).textTheme.titleMedium),
                    Text('\$ 50', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ],
            ),) : Container()
        ],
      ),
    );
  }
}
