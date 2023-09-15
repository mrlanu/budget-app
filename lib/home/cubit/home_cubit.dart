import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/shared/models/summary_tile.dart';
import 'package:budget_app/subcategories/repository/subcategories_repository.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';

import '../../budgets/budgets.dart';
import '../../transactions/models/transaction.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final BudgetRepository _budgetRepository;
  final TransactionsRepository _transactionsRepository;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;
  late final StreamSubscription<Budget> _budgetsSubscription;

  HomeCubit({
    required BudgetRepository budgetRepository,
    required TransactionsRepository transactionsRepository,
    required AccountsRepository accountsRepository,
    required CategoriesRepository categoriesRepository,
    required SubcategoriesRepository subcategoriesRepository,
  })  : _budgetRepository = budgetRepository,
        _transactionsRepository = transactionsRepository,
        super(HomeState(selectedDate: DateTime.now())) {
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(status: HomeStatus.loading));
    _transactionsRepository.initTransactions();
    _budgetsSubscription = _budgetRepository.budget.listen((budget) {
      final sections = _recalculateSections(accounts: budget.accountList);
      emit(state.copyWith(
          categories: budget.categoryList,
          accounts: budget.accountList,
          sectionsSum: sections));
    }, onError: (err) {
      emit(state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'HomeCubit. Something went wrong'));
    });
    _transactionsSubscription =
        _transactionsRepository.transactions.listen((transactions) {
      _onTransactionsChanged(transactions);
    });
    try {} catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure, errorMessage: 'Something went wrong'));
    }
  }

  Future<void> _onTransactionsChanged(List<Transaction> transactions) async {
    emit(state.copyWith(
      status: HomeStatus.loading,
    ));
    final summaries = _getSummariesByCategory(transactions: transactions);
    final sectionsSum = _recalculateSections(transactions: transactions);
    emit(state.copyWith(
      transactions: transactions,
      sectionsSum: sectionsSum,
      summaryList: summaries,
      status: HomeStatus.success,
    ));
  }

  /*Future<void> _onTransfersChanged(List<Transfer> transfers) async {
    emit(state.copyWith(status: HomeStatus.loading));
    // this call will trigger _onAccountsChanged which will redraw UI
    await _accountsRepository.fetchAllAccounts();
  }*/

  /*Future<void> _onAccountsChanged(List<Account> accounts) async {
    var summaries;
    if (state.tab == HomeTab.accounts) {
      summaries = await _getSummariesByAccounts(accounts: accounts);
    }
    final sectionsSum = _recalculateSections(transactions: state.transactions);
    emit(state.copyWith(
      sectionsSum: sectionsSum,
      summaryList:
          state.tab == HomeTab.accounts ? summaries : state.summaryList,
      status: HomeStatus.success,
    ));
  }*/

  Map<String, double> _recalculateSections({List<Transaction>? transactions, List<Account>? accounts}) {
    final groupedTransactions = groupBy(
      transactions ?? state.transactions,
      (Transaction p0) => p0.type,
    );
    final double expSum = groupedTransactions[TransactionType.EXPENSE]
            ?.fold<double>(0,
                (previousValue, element) => previousValue + element.amount!) ??
        0;
    final double incSum = groupedTransactions[TransactionType.INCOME]
            ?.fold<double>(0,
                (previousValue, element) => previousValue + element.amount!) ??
        0;
    final double accSum = (accounts ?? state.accounts)
        .where((acc) => acc.includeInTotal)
        .fold<double>(
            0.0, (previousValue, element) => previousValue + element.balance);
    return {'expenses': expSum, 'incomes': incSum, 'accounts': accSum};
  }

  List<SummaryTile> _getSummariesByCategory(
      {required List<Transaction> transactions}) {
    final groupedTrByCat =
        groupBy(transactions, (Transaction tr) => tr.category!.name);

    List<SummaryTile> summaries = [];
    double allTotal = 0;

    if (state.categories.isNotEmpty) {
      groupedTrByCat.forEach((key, value) {
        final cat = state.categories.where((cat) => cat.name == key).first;
        final double sum = value.fold<double>(
            0.0, (previousValue, element) => previousValue + element.amount!);
        if (cat.type.name == state.tab.name) {
          allTotal = allTotal + sum;
          summaries.add(SummaryTile(
              id: cat.name,
              name: cat.name,
              total: sum,
              iconCodePoint: cat.iconCode));
        }
      });
    }
    return summaries;
  }

  Future<List<SummaryTile>> _getSummariesByAccounts() async {
    final groupedAccByCat =
        groupBy(state.accounts, (Account acc) => acc.categoryName);

    double allTotal = 0;
    List<SummaryTile> summaries = [];
    if (state.categories.isNotEmpty) {
      groupedAccByCat.forEach((key, value) {
        final cat = state.categories.where((cat) => cat.name == key).first;
        final double sum = value.fold<double>(
            0.0, (previousValue, element) => previousValue + element.balance);
        allTotal = allTotal + sum;
        summaries.add(SummaryTile(
            id: cat.name,
            name: cat.name,
            total: sum,
            iconCodePoint: cat.iconCode));
      });
    }

    return summaries;
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(
        status: HomeStatus.loading, tab: HomeTab.values[tabIndex]));
    final summaries = tabIndex == HomeTab.accounts.index
        ? await _getSummariesByAccounts()
        : _getSummariesByCategory(transactions: state.transactions);
    emit(state.copyWith(status: HomeStatus.success, summaryList: summaries));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(status: HomeStatus.loading, selectedDate: dateTime));
    //_transactionsRepository.fetchTransactions(dateTime: dateTime);
    //_transactionsRepository.fetchTransfers(dateTime: dateTime);
  }

  Future<void> changeExpanded(int index) async {
    var summaryList = [...state.summaryList];
    summaryList[index] =
        summaryList[index].copyWith(isExpanded: !summaryList[index].isExpanded);
    emit(state.copyWith(summaryList: summaryList));
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    _budgetsSubscription.cancel();
    return super.close();
  }
}
