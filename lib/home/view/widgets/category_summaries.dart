import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../colors.dart';
import '../../../constants/constants.dart';
import '../../../transactions/models/transactions_view_filter.dart';
import '../../../transactions/view/transactions_list.dart';
import '../../home.dart';

class CategorySummaries extends StatelessWidget {

  CategorySummaries({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(child: BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ExpansionPanelList(
          dividerColor: BudgetColors.teal900,
          expansionCallback: (int index, bool isExpanded) {
            final homeCubit = context.read<HomeCubit>()..changeExpanded(index);
            if (isDisplayDesktop(context)) {
              context.read<TransactionBloc>().add(TransactionFormLoaded(
                  transactionType: homeCubit.state.tab == HomeTab.expenses
                      ? TransactionType.EXPENSE
                      : TransactionType.INCOME,
                  date: homeCubit.state.selectedDate!));
            }
          },
          children: state.summaryList.map<ExpansionPanel>((tile) {
            return ExpansionPanel(
                canTapOnHeader: true,
                backgroundColor: BudgetColors.teal100,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    leading: FaIcon(
                        color: scheme.primary,
                        IconData(tile.iconCodePoint,
                            fontFamily: 'FontAwesomeSolid')),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$ ${tile.total.toStringAsFixed(2)}',
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
        );
      },
    ));
  }
}
