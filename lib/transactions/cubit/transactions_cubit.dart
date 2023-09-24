import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transfer/models/models.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';

import '../../home/cubit/home_cubit.dart';
import '../../shared/models/summary_tile.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import '../models/transactions_view_filter.dart';
import '../repository/transactions_repository.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final TransactionsRepository _transactionsRepository;
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;
  late final StreamSubscription<Budget> _budgetSubscription;

  TransactionsCubit({
    required TransactionsRepository transactionsRepository,
    required BudgetRepository budgetRepository,
    required TransactionsViewFilter filter,
  })  : _transactionsRepository = transactionsRepository,
        _budgetRepository = budgetRepository,
        super(TransactionsState(filter: filter, selectedDate: DateTime.now())) {
    _transactionsRepository.initTransactions();
    _transactionsSubscription =
        _transactionsRepository.transactions.listen((transactions) {
      _onTransactionsChanged(transactions);
    });
    _budgetSubscription = _budgetRepository
        .budget
        .listen((budget) {
      _onBudgetChanged(budget);
    });
  }

  Future<void> _onBudgetChanged(Budget budget) async {
    final sections = _recalculateSections(accounts: budget.accountList);
    emit(state.copyWith(sectionsSum: sections));
  }

  Future<void> _onTransactionsChanged(List<Transaction> transactions) async {
    emit(state.copyWith(status: TransactionsStatus.loading));

    var trTiles = <TransactionTile>[];

    transactions.forEach((tr) {
      final cat = _budgetRepository.getCategoryById(tr.categoryId!);
      final subcategory =
          cat.subcategoryList.where((sc) => tr.subcategoryId == sc.id).first;
      final acc = _budgetRepository.getAccountById(tr.accountId!);
      trTiles.add(tr.toTile(
          account: acc, category: cat, subcategory: subcategory));
    });

    trTiles.sort(
      (a, b) => a.dateTime.compareTo(b.dateTime),
    );

    final sectionsSum = _recalculateSections(transactions: transactions);
    final summaries = _getSummariesByCategory(transactions: transactions);

    emit(state.copyWith(
      transactions: transactions,
        status: TransactionsStatus.success,
        sectionsSum: sectionsSum,
        summaryList: summaries,
        transactionList: trTiles));
  }

  List<SummaryTile> _getSummariesByCategory(
      {required List<Transaction> transactions}) {
    final groupedTrByCat =
    groupBy(transactions, (Transaction tr) => tr.categoryId!);

    List<SummaryTile> summaries = [];

      groupedTrByCat.forEach((key, value) {
        final cat = _budgetRepository.getCategories().where((cat) => cat.id == key).first;
        final double sum = value.fold<double>(
            0.0, (previousValue, element) => previousValue + element.amount!);
        if (cat.type.name == state.tab.name) {
          summaries.add(SummaryTile(
              id: cat.id,
              name: cat.name,
              total: sum,
              iconCodePoint: cat.iconCode));
        }
      });
    return summaries;
  }

  Future<List<SummaryTile>> _getSummariesByAccounts() async {
    final groupedAccByCat =
    groupBy(_budgetRepository.getAccounts(), (Account acc) => acc.categoryId);

    double allTotal = 0;
    List<SummaryTile> summaries = [];

      groupedAccByCat.forEach((key, value) {
        final cat = _budgetRepository.getCategories().where((cat) => cat.id == key).first;
        final double sum = value.fold<double>(
            0.0, (previousValue, element) => previousValue + element.balance);
        allTotal = allTotal + sum;
        summaries.add(SummaryTile(
            id: cat.id,
            name: cat.name,
            total: sum,
            iconCodePoint: cat.iconCode));
      });

    return summaries;
  }

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
    final double accSum = (_budgetRepository.getAccounts())
        .where((acc) => acc.includeInTotal)
        .fold<double>(
        0.0, (previousValue, element) => previousValue + element.balance);
    return {'expenses': expSum, 'incomes': incSum, 'accounts': accSum};
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(
        status: TransactionsStatus.loading, tab: HomeTab.values[tabIndex]));
    final summaries = tabIndex == HomeTab.accounts.index
        ? await _getSummariesByAccounts()
        : _getSummariesByCategory(transactions: state.transactions);
    emit(state.copyWith(status: TransactionsStatus.success, summaryList: summaries));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(status: TransactionsStatus.loading, selectedDate: dateTime));
    //_transactionsRepository.fetchTransactions(dateTime: dateTime);
    //_transactionsRepository.fetchTransfers(dateTime: dateTime);
  }

  Future<void> changeExpanded(int index) async {
    var summaryList = [...state.summaryList];
    summaryList[index] =
        summaryList[index].copyWith(isExpanded: !summaryList[index].isExpanded);
    emit(state.copyWith(summaryList: summaryList));
  }

  Future<void> filterChanged({required TransactionsViewFilter filter}) async {
    emit(state.copyWith(filter: filter));
   // _onSomethingChanged();
  }

  Future<void> deleteTransaction({required String transactionId}) async {
    final deletedTransaction =
        await _transactionsRepository.deleteTransaction(transactionId);
    emit(state.copyWith(lastDeletedTransaction: () => deletedTransaction));
  }

  Future<void> deleteTransfer({required String transferId}) async {
    final deletedTransfer =
        await _transactionsRepository.deleteTransfer(transferId);
    emit(state.copyWith(lastDeletedTransfer: () => deletedTransfer));
  }

  Future<void> undoDelete() async {
    /*final transaction = state.lastDeletedTransaction;
    final transfer = state.lastDeletedTransfer;
    if (transaction == null) {
      emit(state.copyWith(lastDeletedTransfer: () => null));
      await _transactionsRepository.createTransfer(transfer!);
    } else {
      emit(state.copyWith(lastDeletedTransaction: () => null));
      await _transactionsRepository.createTransaction(transaction);
    }*/
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    _budgetSubscription.cancel();
    return super.close();
  }
}
