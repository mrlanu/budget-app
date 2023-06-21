import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/models/account.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/shared/models/budget.dart';
import 'package:budget_app/shared/models/summary_tile.dart';
import 'package:budget_app/subcategories/repository/subcategories_repository.dart';
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
  final SubcategoriesRepository _subcategoriesRepository;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;
  final String budgetId;

  HomeCubit(
      {required TransactionsRepository transactionsRepository,
      required AccountsRepository accountsRepository,
      required CategoriesRepository categoriesRepository,
      required SubcategoriesRepository subcategoriesRepository,
      required this.budgetId})
      : _transactionsRepository = transactionsRepository,
        _accountsRepository = accountsRepository,
        _categoriesRepository = categoriesRepository,
        _subcategoriesRepository = subcategoriesRepository,
        super(HomeState(selectedDate: DateTime.now())) {
    _transactionsSubscription =
        _transactionsRepository.getTransactions().listen((transactions) {
      _onTransactionsChanged(transactions);
    });
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(status: HomeStatus.loading));
    await Future.wait([
      _categoriesRepository.fetchAllCategories(),
      _accountsRepository.fetchAllAccounts(),
      _subcategoriesRepository.fetchSubcategories(),
    ]);
    _transactionsRepository.fetchTransactions(
        budgetId: budgetId, dateTime: DateTime.now());
    _transactionsRepository.fetchTransfers(
        budgetId: budgetId, dateTime: DateTime.now());
  }

  Future<void> _onTransactionsChanged(List<Transaction> transactions) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final categories = await _categoriesRepository.getCategories().first;
    final accounts = await _accountsRepository.getAccounts().first;

    final summaries = _getSummariesByCategory(
        transactions: transactions, categories: categories);
    final sectionsSum =
        _recalculateSections(transactions: transactions, accounts: accounts);

    emit(state.copyWith(
      transactions: transactions,
      categories: categories,
      accounts: accounts,
      sectionsSum: sectionsSum,
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

  List<SummaryTile> _getSummariesByCategory(
      {required List<Transaction> transactions,
      required List<Category> categories}) {
    final groupedTrByCat =
        groupBy(transactions, (Transaction tr) => tr.categoryId);

    List<SummaryTile> summaries = [];
    double allTotal = 0;

    if (categories.isNotEmpty) {
      groupedTrByCat.forEach((key, value) {
        final cat = categories.where((element) => element.id == key).first;
        final double sum = value.fold<double>(
            0.0, (previousValue, element) => previousValue + element.amount!);
        if (cat.transactionType.name == state.tab.name) {
          allTotal = allTotal + sum;
          summaries.add(SummaryTile(
              id: cat.id!,
              name: cat.name,
              total: sum,
              iconCodePoint: cat.iconCode!));
        }
      });
    }
    summaries.insert(
        0,
        SummaryTile(
            id: state.tab.name == 'EXPENSE' ? 'all_expenses' : 'all_incomes',
            name: 'All',
            total: allTotal,
            iconCodePoint: 62335));
    return summaries;
  }

  List<SummaryTile> _getSummariesByAccounts(
      {required List<Account> accounts, required List<Category> categories}) {
    final groupedAccByCat = groupBy(accounts, (Account acc) => acc.categoryId);

    List<SummaryTile> summaries = [];
    if (categories.isNotEmpty) {
      groupedAccByCat.forEach((key, value) {
        final cat = categories.where((element) => element.id == key).first;
        final double sum = value.fold<double>(
            0.0, (previousValue, element) => previousValue + element.balance);

        summaries.add(SummaryTile(
            id: cat.id!,
            name: cat.name,
            total: sum,
            iconCodePoint: cat.iconCode!));
      });
    }

    return summaries;
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(
        status: HomeStatus.loading, tab: HomeTab.values[tabIndex]));
    final summaries = tabIndex == HomeTab.accounts.index
        ? _getSummariesByAccounts(
            accounts: state.accounts, categories: state.categories)
        : _getSummariesByCategory(
            transactions: state.transactions, categories: state.categories);
    emit(state.copyWith(status: HomeStatus.success, summaryList: summaries));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(status: HomeStatus.loading));
    _transactionsRepository.fetchTransactions(
        budgetId: budgetId, dateTime: dateTime);
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    return super.close();
  }
}
