import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/colors.dart';
import '../../home.dart';
import '../../models/summary_tile.dart';

class CategorySummaryList extends StatelessWidget {
  const CategorySummaryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return CategorySummaryListView(
          summaryList: state.summariesByCategory,
        );
      },
    );
  }
}

class CategorySummaryListView extends StatefulWidget {
  CategorySummaryListView({super.key, this.summaryList = const []});

  final List<SummaryTile> summaryList;

  @override
  State<CategorySummaryListView> createState() =>
      _CategorySummaryListViewState();
}

class _CategorySummaryListViewState extends State<CategorySummaryListView> {
  late List<bool> isExpandedList;

  @override
  void initState() {
    super.initState();
    isExpandedList = List.filled(widget.summaryList.length, false);
  }

  @override
  void didUpdateWidget(covariant CategorySummaryListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.summaryList.length != oldWidget.summaryList.length) {
      setState(() {
        isExpandedList = List.filled(widget.summaryList.length, false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
                    backgroundColor: BudgetColors.warning,
                    content: Text('Transaction has been deleted.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
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
            child: ExpansionPanelList(
                expandIconColor: Colors.black,
                dividerColor: BudgetColors.primary,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    isExpandedList[index] = isExpanded;
                  });
                  /*if (isDisplayDesktop(context)) {
                context.read<TransactionBloc>().add(TransactionFormLoaded(
                      transactionType: state.tab == HomeTab.expenses
                          ? TransactionType.EXPENSE
                          : TransactionType.INCOME,
                    ));
              }*/
                },
                children: List.generate(widget.summaryList.length, (index) {
                  final summary = widget.summaryList[index];
                  return ExpansionPanel(
                      canTapOnHeader: true,
                      backgroundColor: BudgetColors.lightContainer,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          leading: FaIcon(
                              color: BudgetColors.primary,
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
                                  color: BudgetColors.primary,
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            summary.name,
                            style: TextStyle(
                              fontSize: textTheme.titleLarge!.fontSize,
                              fontWeight: FontWeight.bold,
                              color: BudgetColors.primary,
                            ),
                          ),
                        );
                      },
                      body: TransactionsList(
                          transactionTiles: summary.comprehensiveTr),
                      isExpanded: isExpandedList[index]);
                }))));
  }
}
