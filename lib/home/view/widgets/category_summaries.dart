import 'package:budget_app/home/cubit/home_cubit.dart' as homeCubit;
import 'package:budget_app/transactions/cubit/transactions_cubit.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../colors.dart';
import '../../../constants/constants.dart';
import '../../../transactions/view/transactions_list.dart';
import '../../cubit/home_cubit.dart';

class CategorySummaries extends StatelessWidget {
  CategorySummaries({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return MultiBlocListener(
      listeners: [
        BlocListener<homeCubit.HomeCubit, homeCubit.HomeState>(
          listenWhen: (previous, current) => previous.tab != current.tab,
            listener: (context, state) {
              BlocProvider.of<TransactionsCubit>(context).setTab(state.tab.index);
            },),
        BlocListener<homeCubit.HomeCubit, homeCubit.HomeState>(
          listenWhen: (previous, current) => previous.selectedDate != current.selectedDate,
            listener: (context, state) {
              BlocProvider.of<TransactionsCubit>(context).changeDate(state.selectedDate!);
            },),
      ],
      child: SingleChildScrollView(
          child: BlocBuilder<TransactionsCubit, TransactionsState>(
        builder: (context, state) {
          return ExpansionPanelList(
            dividerColor: BudgetColors.teal900,
            expansionCallback: (int index, bool isExpanded) {
              final transactionsCubit = context.read<TransactionsCubit>()
                ..changeExpanded(index);
              if (isDisplayDesktop(context)) {
                context.read<TransactionBloc>().add(TransactionFormLoaded(
                    transactionType:
                        transactionsCubit.state.tab == HomeTab.expenses
                            ? TransactionType.EXPENSE
                            : TransactionType.INCOME,
                    date: transactionsCubit.state.selectedDate!));
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
                  body: TransactionsList(transactionTiles: tile.transactionTiles),
                  isExpanded: tile.isExpanded);
            }).toList(),
          );
        },
      )),
    );
  }
}
