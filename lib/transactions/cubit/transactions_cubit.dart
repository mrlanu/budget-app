import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/subcategories/repository/subcategories_repository.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transfer/models/models.dart';
import 'package:equatable/equatable.dart';

import '../models/transaction.dart';
import '../models/transactions_view_filter.dart';
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
    required TransactionsViewFilter filter,
  })  : _transactionsRepository = transactionsRepository,
        _categoriesRepository = categoriesRepository,
        _subcategoriesRepository = subcategoriesRepository,
        _accountsRepository = accountsRepository,
        _budgetId = budgetId,
        super(TransactionsState(filter: filter)) {
    _transactionsSubscription =
        _transactionsRepository.getTransactions().listen((_) {
      _onSomethingChanged();
    });
    _transfersSubscription =
        _transactionsRepository.getTransfers().skip(1).listen((_) {
      _onSomethingChanged();
    });
  }

  Future<void> _onSomethingChanged() async {
    var trTiles = <TransactionTile>[];

    final transactions = await _transactionsRepository.getTransactions().first;
    final transfers = await _transactionsRepository.getTransfers().first;
    final categories = await _categoriesRepository.getCategories().first;
    final subcategories = await _subcategoriesRepository.getSubcategories().first;
    final accounts = await _accountsRepository.getAccounts().first;

    transactions.forEach((element) {
      final cat = categories.where((c) => element.categoryId == c.id).first;
      final subcategory = subcategories.where((sc) => element.subcategoryId == sc.id).first;
      final acc = accounts.where((a) => element.accountId == a.id).first;
      trTiles.add(element.toTile(account: acc, category: cat, subcategory: subcategory));
    });

    if(state.filter.type == TransactionsViewFilterTypes.accountId){
      transfers.forEach((element) {
        final fromAcc = accounts.where((a) => element.fromAccountId == a.id).first;
        final toAcc = accounts.where((a) => element.toAccountId == a.id).first;
        trTiles.add(element.toTile(tabAccId: state.filter.filterId!, fromAccount: fromAcc, toAccount: toAcc));
      });
    }
    trTiles.sort(
          (a, b) => a.dateTime.compareTo(b.dateTime),
    );
    emit(state.copyWith(
        status: TransactionsStatus.success,
        transactionList: trTiles));
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
