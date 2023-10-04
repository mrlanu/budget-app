import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/charts/charts.dart';
import 'package:budget_app/constants/constants.dart';
import 'package:budget_app/drawer/main_drawer.dart';
import 'package:budget_app/summary/view/summary_page.dart';
import 'package:budget_app/transactions/cubit/transactions_cubit.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transactions/transaction/view/transaction_page.dart';
import 'package:budget_app/transfer/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../colors.dart';
import '../../debt_payoff_planner/view/payoff_page.dart';
import '../../shared/widgets/paginator/month_paginator.dart';
import '../../transactions/repository/transactions_repository.dart';
import '../../transactions/transaction/bloc/transaction_bloc.dart';
import '../../transfer/bloc/transfer_bloc.dart';
import '../cubit/home_cubit.dart';
import '../home.dart';

class HomeDesktopPage extends StatelessWidget {
  const HomeDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionBloc(
            transactionsRepository: context.read<TransactionsRepositoryImpl>(),
            budgetRepository: context.read<BudgetRepository>()
          )..add(TransactionFormLoaded(
              transactionType: TransactionType.EXPENSE,
              date: context.read<TransactionsCubit>().state.selectedDate!)),
        ),
        BlocProvider(
          create: (context) => TransferBloc(
            transactionsRepository: context.read<TransactionsRepositoryImpl>(),
            budgetRepository: context.read<BudgetRepository>()
          )..add(TransferFormLoaded()),
        ),
      ],
      child: Scaffold(backgroundColor: BudgetColors.teal50, body: HomeGrid()),
    );
  }
}

class HomeGrid extends StatefulWidget {
  const HomeGrid({super.key});

  @override
  State<HomeGrid> createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MainDrawer(tabController: _tabController),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              HomeViewDesktop(),
              Center(child: Container(width: w * 0.5, height: h * 0.9, child: SummaryPage())),
              TrendChartDesktopView(),
              DebtPayoffViewDesktop(),
            ],
          ),
        )
      ],
    );
  }
}

class HomeViewDesktop extends StatelessWidget {
  const HomeViewDesktop();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.03),
      child: BlocListener<TransactionsCubit, TransactionsState>(
        listenWhen: (previous, current) =>
            previous.tab != current.tab && current.tab == HomeTab.accounts,
        listener: (context, state) {
          // it has been added for update accounts during first tab open
          //context.read<AccountsCubit>().budgetChanged();
        },
        child: BlocBuilder<TransactionsCubit, TransactionsState>(
            builder: (context, state) => Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(15),
                      width: w * 0.3,
                      height: 80,
                      decoration: BoxDecoration(
                          color: BudgetColors.teal900,
                          borderRadius: BorderRadius.circular(15)),
                      child: MonthPaginator(
                        fontSize: 20,
                        color: BudgetColors.teal50,
                        onLeft: (date) =>
                            context.read<TransactionsCubit>().changeDate(date),
                        onRight: (date) =>
                            context.read<TransactionsCubit>().changeDate(date),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              Card(
                                color: BudgetColors.teal50,
                                elevation: 5,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  width: w * 0.3,
                                  height: h * 0.7,
                                  child: state.status == TransactionsStatus.loading
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : CategorySummaries(),
                                ),
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            children: [
                              Card(
                                  color: BudgetColors.teal50,
                                  elevation: 5,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    width: w * 0.3,
                                    height: h * 0.7,
                                    child: state.tab == HomeTab.accounts
                                        ? TransferWindow.window(
                                            transactionType:
                                                TransactionType.TRANSFER)
                                        : TransactionWindow.window(
                                            transactionType:
                                                TransactionType.EXPENSE),
                                  )) //TransactionsViewBody())
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: w * 0.3,
                      decoration: BoxDecoration(
                          color: BudgetColors.teal900,
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipPath(
                        clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: HomeBottomNavBar(
                            //selectedTab: state.tab,
                            sectionsSum: context.read<HomeCubit>().state.sectionsSum),
                      ),
                    )
                  ],
                )),
      ),
    );
  }
}
