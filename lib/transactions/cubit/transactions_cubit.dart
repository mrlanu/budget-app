import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/shared/models/transaction_interface.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transfer/models/models.dart';
import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';

import '../../home/cubit/home_cubit.dart';
import '../../shared/models/summary_tile.dart';
import '../models/transaction.dart';
import '../models/transactions_view_filter.dart';
import '../repository/transactions_repository.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final TransactionsRepository _transactionsRepository;
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<List<ITransaction>> _transactionsSubscription;
  late final StreamSubscription<Budget> _budgetSubscription;

  TransactionsCubit({
    required TransactionsRepository transactionsRepository,
    required BudgetRepository budgetRepository,
  })  : _transactionsRepository = transactionsRepository,
        _budgetRepository = budgetRepository,
        super(TransactionsState(selectedDate: DateTime.now())) {
    _transactionsRepository.initTransactions(DateTime.now());
    _transactionsSubscription =
        _transactionsRepository.transactions.listen((transactions) {
      _onTransactionsChanged(transactions);
    });
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      _onBudgetChanged(budget);
    });
  }

  Future<void> _onBudgetChanged(Budget budget) async {}

  Future<void> _onTransactionsChanged(List<ITransaction> transactions) async {
    emit(state.copyWith(status: TransactionsStatus.loading));

    var trTiles = <TransactionTile>[];

    transactions.forEach((tr) {
      if (tr.isTransaction()) {
        final transaction = tr as Transaction;
        final cat = _budgetRepository.getCategoryById(transaction.categoryId!);
        final subcategory = cat.subcategoryList
            .where((sc) => transaction.subcategoryId == sc.id)
            .first;
        final acc = _budgetRepository.getAccountById(transaction.accountId!);
        trTiles.add(transaction.toTile(
            account: acc, category: cat, subcategory: subcategory));
      } else {
        final transfer = tr as Transfer;
        trTiles.addAll(transfer.toTiles(
            fromAccount:
                _budgetRepository.getAccountById(transfer.fromAccountId),
            toAccount: _budgetRepository.getAccountById(transfer.toAccountId)));
      }
    });

    trTiles.sort(
      (a, b) => a.dateTime.compareTo(b.dateTime),
    );

    emit(state.copyWith(
        status: TransactionsStatus.success,
        summaryList: _switchSummaries(trTiles),
        transactionTiles: trTiles,
        transactions: transactions));
  }

  List<SummaryTile> _switchSummaries(
          [List<TransactionTile>? transactionTiles]) =>
      switch (state.tab) {
        HomeTab.accounts => _getSummariesByAccounts(
            transactionTiles: transactionTiles ?? state.transactionTiles),
        HomeTab.expenses => _getSummariesByCategory(
            transactionTiles: (transactionTiles ?? state.transactionTiles)
                .where((tr) => tr.type == TransactionType.EXPENSE)
                .toList()),
        HomeTab.income => _getSummariesByCategory(
            transactionTiles: (transactionTiles ?? state.transactionTiles)
                .where((tr) => tr.type == TransactionType.INCOME)
                .toList()),
      };

  List<SummaryTile> _getSummariesByCategory(
      {required List<TransactionTile> transactionTiles}) {
    List<SummaryTile> summaries = [];
    final transactions =
        transactionTiles.where((tr) => tr.toAccount == null).toList();
    final groupedTrByCat =
        groupBy(transactions, (TransactionTile tr) => tr.category!);

    groupedTrByCat.forEach((key, value) {
      final double sum = value.fold<double>(
          0.0, (previousValue, element) => previousValue + element.amount);

      summaries.add(SummaryTile(
          id: key.id,
          name: key.name,
          total: sum,
          transactionTiles: value,
          iconCodePoint: key.iconCode));
    });
    return summaries;
  }

  List<SummaryTile> _getSummariesByAccounts(
      {required List<TransactionTile> transactionTiles}) {
    List<SummaryTile> summaries = [];

    _budgetRepository.getAccounts().forEach((acc) {
      summaries.add(SummaryTile(
          id: acc.id,
          name: acc.name,
          total: acc.balance,
          transactionTiles: transactionTiles
              .where((tr) =>
                  (tr.fromAccount!.id == acc.id &&
                      tr.type != TransactionType.TRANSFER) ||
                  (tr.toAccount?.id == acc.id && tr.title == 'Transfer in') ||
                  (tr.fromAccount?.id == acc.id && tr.title == 'Transfer out'))
              .toList(),
          iconCodePoint:
              _budgetRepository.getCategoryById(acc.categoryId).iconCode));
    });

    return summaries;
  }

  Future<void> setTab(int tabIndex) async {
    emit(state.copyWith(
        status: TransactionsStatus.loading, tab: HomeTab.values[tabIndex]));
    emit(state.copyWith(
        status: TransactionsStatus.success, summaryList: _switchSummaries()));
  }

  Future<void> changeDate(DateTime dateTime) async {
    emit(state.copyWith(
        status: TransactionsStatus.loading, selectedDate: dateTime));
    _transactionsRepository.initTransactions(dateTime);
  }

  Future<void> changeExpanded(int index) async {
    var summaryList = [...state.summaryList];
    summaryList[index] =
        summaryList[index].copyWith(isExpanded: !summaryList[index].isExpanded);
    emit(state.copyWith(summaryList: summaryList));
  }

  Future<void> deleteTransaction(
      {required TransactionTile transactionTile}) async {
    await _transactionsRepository.deleteTransactionOrTransfer(
        transaction: transactionTile,
        budget: await _budgetRepository.budget.first);
    final lastDeleted =
        state.transactions.where((tr) => tr.getId == transactionTile.id).first;
    final newSummary = _getSummariesByCategory(
        transactionTiles: state.transactionTiles
            .where((trT) => trT.id != transactionTile.id)
            .toList());
    emit(state.copyWith(
        summaryList: newSummary, lastDeletedTransaction: () => lastDeleted));
  }

  Future<void> undoDelete() async {
    if (state.lastDeletedTransaction!.isTransaction()) {
      await _transactionsRepository.saveTransaction(
          transaction: state.lastDeletedTransaction! as Transaction,
          budget: await _budgetRepository.budget.first);
    } else {
      await _transactionsRepository.saveTransfer(
          transfer: state.lastDeletedTransaction! as Transfer,
          budget: await _budgetRepository.budget.first);
    }
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    _budgetSubscription.cancel();
    return super.close();
  }
}
