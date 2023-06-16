import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/models/account.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/shared/models/budget.dart';
import 'package:budget_app/shared/models/summary_by.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:equatable/equatable.dart';
import "package:collection/collection.dart";

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransactionsRepository _transactionsRepository;
  final AccountsRepository _accountsRepository;
  final CategoriesRepository _categoriesRepository;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;
  final String budgetId;

  HomeCubit(
      {required TransactionsRepository transactionsRepository,
      required AccountsRepository accountsRepository,
      required CategoriesRepository categoriesRepository,
      required this.budgetId})
      : _transactionsRepository = transactionsRepository,
        _accountsRepository = accountsRepository,
        _categoriesRepository = categoriesRepository,
        super(HomeState(selectedDate: DateTime.now())) {
    _transactionsSubscription =
        _transactionsRepository.getTransactions().listen((transactions) {
      _onTransactionsChanged(transactions);
    });
    _init();
  }

  Future<void> _init() async {
    _categoriesRepository.fetchAllCategories();
    _accountsRepository.fetchAllAccounts();
    _transactionsRepository.fetchTransactions(budgetId: budgetId, dateTime: DateTime.now());
  }

  Future<void> _onTransactionsChanged(List<Transaction> transactions) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final categories = await _categoriesRepository.getCategories().first;
    final accounts = await _accountsRepository.getAccounts().first;

    final summaries = _getSummariesByCategory(
        transactions: transactions, categories: categories);
    final sumsOfSections =
        _recalculateSections(transactions: transactions, accounts: accounts);

    emit(state.copyWith(
      transactions: transactions,
      categories: categories,
      incomesSum: sumsOfSections['incomes'],
      expensesSum: sumsOfSections['expenses'],
      accountsSum: sumsOfSections['accounts'],
      summaryList: summaries,
      status: HomeStatus.success,
    ));
  }

  Map<String, double> _recalculateSections(
      {required List<Transaction> transactions,
      required List<Account> accounts}) {
    final groupedTransactions = groupBy(
      transactions,
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
    final double accSum = accounts.fold<double>(
        0.0, (previousValue, element) => previousValue + element.balance);
    return {'expenses': expSum, 'incomes': incSum, 'accounts': accSum};
  }

  List<SummaryBy> _getSummariesByCategory(
      {required List<Transaction> transactions,
      required List<Category> categories}) {
    final groupedTrByCat =
        groupBy(transactions, (Transaction tr) => tr.categoryId);

    List<SummaryBy> summaries = [];
    double allTotal = 0;

    if (categories.isNotEmpty) {
      groupedTrByCat.forEach((key, value) {
        final cat = categories.where((element) => element.id == key).first;
        final double sum = value.fold<double>(
            0.0, (previousValue, element) => previousValue + element.amount!);
        if (cat.transactionType.name == state.tab.name) {
          allTotal = allTotal + sum;
          summaries.add(SummaryBy(
              id: '',
              name: cat.name,
              total: sum,
              iconCodePoint: cat.iconCode!));
        }
      });
    }
    summaries.insert(0, SummaryBy(id: '', name: 'All', total: allTotal, iconCodePoint: 62335));
    return summaries;
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(
        status: HomeStatus.loading, tab: HomeTab.values[tabIndex]));
    final summaries = _getSummariesByCategory(
        transactions: state.transactions, categories: state.categories);
    emit(state.copyWith(status: HomeStatus.success, summaryList: summaries));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(status: HomeStatus.loading));
    /*final data = await _fetchHomePageData(dateTime: dateTime);
    emit(state.copyWith(
        status: HomeStatus.success,
        summaryList: data['summaryList'],
        selectedDate: dateTime));*/
  }


  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    return super.close();
  }
}
