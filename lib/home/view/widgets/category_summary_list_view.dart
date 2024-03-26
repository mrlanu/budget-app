import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../colors.dart';
import '../../../constants/constants.dart';
import '../../../transaction/transaction.dart';
import '../../home.dart';

class CategorySummaryList extends StatelessWidget {
  const CategorySummaryList({super.key, this.homeTab = HomeTab.expenses});

  final HomeTab homeTab;

  @override
  Widget build(BuildContext context) {
    return CategorySummaryListView();
  }
}

class CategorySummaryListView extends StatelessWidget {
  CategorySummaryListView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) =>
              previous.lastDeletedTransaction !=
                  current.lastDeletedTransaction &&
              current.lastDeletedTransaction != null,
          listener: (context, state) {
            final deletedTransaction = state.lastDeletedTransaction!;
            final messenger = ScaffoldMessenger.of(context);
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: BudgetColors.red800,
                  content: Text('Transaction has been deleted.',
                      style: TextStyle(
                          color: BudgetColors.teal900,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  action: SnackBarAction(
                    textColor: Colors.black,
                    label: 'UNDO',
                    onPressed: () {
                      messenger.hideCurrentSnackBar();
                      context.read<HomeCubit>().undoDelete();
                    },
                  ),
                ),
              );
          },
        ),
      ],
      child: SingleChildScrollView(
          child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return ExpansionPanelList(
            dividerColor: BudgetColors.teal900,
            expansionCallback: (int index, bool isExpanded) {
              final transactionsCubit = context.read<HomeCubit>()
                ..changeExpanded(index);
              if (isDisplayDesktop(context)) {
                context.read<TransactionBloc>().add(TransactionFormLoaded(
                    transactionType:
                        transactionsCubit.state.tab == HomeTab.expenses
                            ? TransactionType.EXPENSE
                            : TransactionType.INCOME,));
              }
            },
            children: state.summaryList.map<ExpansionPanel>((summary) {
              return ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: BudgetColors.teal100,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      leading: FaIcon(
                          color: scheme.primary,
                          IconData(summary.iconCodePoint,
                              fontFamily: 'FontAwesomeSolid')),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$ ${summary.total.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: textTheme.titleLarge!.fontSize,
                                fontWeight: FontWeight.bold,
                                color: scheme.primary),
                          ),
                        ],
                      ),
                      title: Text(
                        summary.name,
                        style: TextStyle(
                            fontSize: textTheme.titleLarge!.fontSize,
                            fontWeight: FontWeight.bold,
                            color: scheme.primary),
                      ),
                    );
                  },
                  body:
                      TransactionsList(transactionTiles: summary.transactionTiles),
                  isExpanded: summary.isExpanded);
            }).toList(),
          );
        },
      )),
    );
  }
}
