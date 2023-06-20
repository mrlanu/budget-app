import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/subcategories/repository/subcategories_repository.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transfer/models/models.dart';
import 'package:equatable/equatable.dart';

import '../models/transaction.dart';
import '../models/transactions_filter.dart';
import '../repository/transactions_repository.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final TransactionsRepository _transactionsRepository;
  final CategoriesRepository _categoriesRepository;
  final SubcategoriesRepository _subcategoriesRepository;
  final AccountsRepository _accountsRepository;
  final String _budgetId;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;
  late final StreamSubscription<List<Transfer>> _transfersSubscription;

  TransactionsCubit({
    required String budgetId,
    required TransactionsRepository transactionsRepository,
    required CategoriesRepository categoriesRepository,
    required SubcategoriesRepository subcategoriesRepository,
    required AccountsRepository accountsRepository,
    required TransactionsFilter filter,
    required DateTime filterDate,
  })  : _transactionsRepository = transactionsRepository,
        _categoriesRepository = categoriesRepository,
        _subcategoriesRepository = subcategoriesRepository,
        _accountsRepository = accountsRepository,
        _budgetId = budgetId,
        super(TransactionsState(filter: filter, filterDate: filterDate)) {
    _transactionsSubscription =
        _transactionsRepository.getTransactions().listen((transactions) {
      _onTransactionsChanged(transactions);
    });
    _transfersSubscription =
        _transactionsRepository.getTransfers().skip(1).listen((transfers) {
      _onTransfersChanged(transfers);
    });
  }

  Future<void> _onTransactionsChanged(List<Transaction> transactions) async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    var filteredTransactions = <TransactionTile>[];
    switch (state.filter.filterBy) {
      case FilterBy.allExpenses:
        {
          filteredTransactions = transactions
              .where(
                (element) => element.type == TransactionType.EXPENSE,
              )
              .map((e) => e.toTile())
              .toList();
        }
        break;
      case FilterBy.allIncomes:
        {
          filteredTransactions = transactions
              .where(
                (element) => element.type == TransactionType.INCOME,
              )
              .map((e) => e.toTile())
              .toList();
        }
        break;
      case FilterBy.categoryId:
        {
          filteredTransactions = transactions
              .where((element) => element.categoryId == state.filter.id)
              .map((e) => e.toTile())
              .toList();
        }
        break;
      case FilterBy.accountId:
        {
          filteredTransactions = await _doSomething(transactions: transactions);
        }
    }
    emit(state.copyWith(
        status: TransactionsStatus.success,
        transactionList: filteredTransactions));
  }

  Future<List<TransactionTile>> _doSomething(
      {List<Transaction>? transactions, List<Transfer>? transfers}) async {
    var filteredTransactions = <TransactionTile>[];
    if (transactions != null) {
      filteredTransactions = transactions
          .where((element) => element.accountId == state.filter.id)
          .map((e) => e.toTile())
          .toList();
      final transfers = await _transactionsRepository.getTransfers().first;
      final transferTiles =
          transfers.map((e) => e.toTile(accountId: state.filter.id!)).toList();
      filteredTransactions.addAll(transferTiles);
      filteredTransactions.sort(
        (a, b) => a.dateTime.compareTo(b.dateTime),
      );
    } else {
      filteredTransactions = transfers!
          .where((element) => element.fromAccountId == state.filter.id || element.toAccountId == state.filter.id)
          .map((e) => e.toTile(accountId: state.filter.id!, ))
          .toList();
      final transactions = await _transactionsRepository.getTransactions().first;
      final filteredTrans = transactions.where((element) => element.accountId == state.filter.id).toList();
      final transactionTiles =
      filteredTrans.map((e) => e.toTile()).toList();
      filteredTransactions.addAll(transactionTiles);
      filteredTransactions.sort(
            (a, b) => a.dateTime.compareTo(b.dateTime),
      );
    }
    return filteredTransactions;
  }

  Future<void> _onTransfersChanged(List<Transfer> transfers) async {
    final filteredTransactions = await _doSomething(transfers: transfers);
    emit(state.copyWith(
        status: TransactionsStatus.success,
        transactionList: filteredTransactions));
  }

  Future<void> deleteTransaction({required String transactionId}) async {
    final deletedTransaction = await _transactionsRepository.deleteTransaction(transactionId);
    emit(state.copyWith(lastDeletedTransaction: () => deletedTransaction));
  }

  Future<void> deleteTransfer({required String transferId}) async {
    await _transactionsRepository.deleteTransfer(transferId);
    emit(state.copyWith(lastDeletedTransaction: () => null));
  }

  Future<void> undoDelete() async {
    final tr = state.lastDeletedTransaction!;
    emit(state.copyWith(lastDeletedTransaction: () => null));
    await _transactionsRepository.createTransaction(tr);
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    _transfersSubscription.cancel();
    return super.close();
  }
}
