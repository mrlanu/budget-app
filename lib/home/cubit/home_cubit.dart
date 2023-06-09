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
import 'package:budget_app/transfer/transfer.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TransactionsRepository _transactionsRepository;
  final AccountsRepository _accountsRepository;
  final CategoriesRepository _categoriesRepository;
  final SubcategoriesRepository _subcategoriesRepository;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;
  late final StreamSubscription<List<Transfer>> _transfersSubscription;
  late final StreamSubscription<List<Account>> _accountsSubscription;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  HomeCubit({
    required TransactionsRepository transactionsRepository,
    required AccountsRepository accountsRepository,
    required CategoriesRepository categoriesRepository,
    required SubcategoriesRepository subcategoriesRepository,
  })  : _transactionsRepository = transactionsRepository,
        _accountsRepository = accountsRepository,
        _categoriesRepository = categoriesRepository,
        _subcategoriesRepository = subcategoriesRepository,
        super(HomeState(selectedDate: DateTime.now())) {
    _transactionsSubscription =
        _transactionsRepository.getTransactions().listen((transactions) {
      _onTransactionsChanged(transactions);
    });
    _transfersSubscription =
        _transactionsRepository.getTransfers().listen((transfers) {
      _onTransfersChanged(transfers);
    });
    _accountsSubscription =
        _accountsRepository.getAccounts().skip(2).listen((accounts) {
      _onAccountsChanged(accounts);
    });
    _categoriesSubscription =
        _categoriesRepository.getCategories().skip(1).listen((categories) {
      _onCategoriesChanged(categories);
    });
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(status: HomeStatus.loading));
    await Future.wait([
      _categoriesRepository.fetchAllCategories(),
      //_accountsSubscription skip 1
      _accountsRepository.fetchAllAccounts(),
      _subcategoriesRepository.fetchSubcategories(),
    ]);
    _transactionsRepository.fetchTransactions(dateTime: DateTime.now());
    _transactionsRepository.fetchTransfers(dateTime: DateTime.now());
  }

  Future<void> _onTransactionsChanged(List<Transaction> transactions) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final categories = await _categoriesRepository.getCategories().first;
    //_accountsSubscription skip 2
    await _accountsRepository.fetchAllAccounts();
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

  Future<void> _onTransfersChanged(List<Transfer> transfers) async {
    emit(state.copyWith(status: HomeStatus.loading));
    // this call will trigger _onAccountsChanged which will redraw UI
    await _accountsRepository.fetchAllAccounts();
  }

  Future<void> _onAccountsChanged(List<Account> accounts) async {
    var summaries;
    if (state.tab == HomeTab.accounts) {
      summaries = await _getSummariesByAccounts(accounts: accounts);
    }
    final sectionsSum = _recalculateSections(
        transactions: state.transactions, accounts: accounts);
    emit(state.copyWith(
      accounts: accounts,
      sectionsSum: sectionsSum,
      summaryList:
          state.tab == HomeTab.accounts ? summaries : state.summaryList,
      status: HomeStatus.success,
    ));
  }

  Future<void> _onCategoriesChanged(List<Category> categories) async {
    var summaries = await _getSummariesByAccounts(accounts: state.accounts);
    emit(state.copyWith(
      summaryList: summaries,
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

  Future<List<SummaryTile>> _getSummariesByAccounts(
      {required List<Account> accounts}) async {
    final categories = await _categoriesRepository.getCategories().first;
    final groupedAccByCat = groupBy(accounts, (Account acc) => acc.categoryId);

    double allTotal = 0;
    List<SummaryTile> summaries = [];
    if (categories.isNotEmpty) {
      groupedAccByCat.forEach((key, value) {
        final cat = categories.where((element) => element.id == key).first;
        final double sum = value.fold<double>(
            0.0, (previousValue, element) => previousValue + element.balance);
        allTotal = allTotal + sum;
        summaries.add(SummaryTile(
            id: cat.id!,
            name: cat.name,
            total: sum,
            iconCodePoint: cat.iconCode!));
      });
      summaries.insert(
          0,
          SummaryTile(
              id: 'all_accounts',
              name: 'All',
              total: allTotal,
              iconCodePoint: 60978));
    }

    return summaries;
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(
        status: HomeStatus.loading, tab: HomeTab.values[tabIndex]));
    final summaries = tabIndex == HomeTab.accounts.index
        ? await _getSummariesByAccounts(accounts: state.accounts)
        : _getSummariesByCategory(
            transactions: state.transactions, categories: state.categories);
    emit(state.copyWith(status: HomeStatus.success, summaryList: summaries));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(status: HomeStatus.loading));
    _transactionsRepository.fetchTransactions(dateTime: dateTime);
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    _accountsSubscription.cancel();
    _categoriesSubscription.cancel();
    _transfersSubscription.cancel();
    return super.close();
  }
}
