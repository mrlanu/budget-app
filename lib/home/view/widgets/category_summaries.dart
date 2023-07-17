import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../shared/models/summary_tile.dart';
import '../../../transactions/models/transactions_view_filter.dart';
import '../../../transactions/view/transactions_list.dart';

class CategorySummaries extends StatefulWidget {
  final List<SummaryTile> summaryList;
  final Key key;

  CategorySummaries({required this.summaryList, required this.key})
      : super(key: key);

  @override
  State<CategorySummaries> createState() => _CategorySummariesState();
}

class _CategorySummariesState extends State<CategorySummaries> {
  late final List<SummaryTile> _summaryList;

  @override
  void initState() {
    super.initState();
    _summaryList = widget.summaryList;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
        child: ExpansionPanelList(
      dividerColor: BudgetColors.teal900,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _summaryList[index] =
              _summaryList[index].copyWith(isExpanded: !isExpanded);
        });
      },
      children: _summaryList.map<ExpansionPanel>((tile) {
        return ExpansionPanel(
            canTapOnHeader: true,
            backgroundColor: BudgetColors.teal100,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                leading: Icon(
                    color: scheme.primary,
                    IconData(tile.iconCodePoint, fontFamily: 'MaterialIcons')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$ ${tile.total.toString()}',
                      style: TextStyle(
                          fontSize: textTheme.titleLarge!.fontSize,
                          fontWeight: FontWeight.bold,
                          color: scheme.primary),
                    ),
                  ],
                ),
                title: Text(
                  tile.name,
                  style: TextStyle(
                      fontSize: textTheme.titleLarge!.fontSize,
                      fontWeight: FontWeight.bold,
                      color: scheme.primary),
                ),
              );
            },
            body: TransactionsList(
                    filter: TransactionsViewFilter(
                        type: TransactionsViewFilterTypes.categoryId,
                        filterId: tile.id)),
            isExpanded: tile.isExpanded);
      }).toList(),
    ));
  }
}
