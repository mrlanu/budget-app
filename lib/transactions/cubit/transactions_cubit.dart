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
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;
  late final StreamSubscription<List<Transfer>> _transfersSubscription;

  TransactionsCubit({
    required TransactionsRepository transactionsRepository,
    required CategoriesRepository categoriesRepository,
    required SubcategoriesRepository subcategoriesRepository,
    required AccountsRepository accountsRepository,
    required TransactionsViewFilter filter,
  })  : _transactionsRepository = transactionsRepository,
        _categoriesRepository = categoriesRepository,
        _subcategoriesRepository = subcategoriesRepository,
        _accountsRepository = accountsRepository,
        super(TransactionsState(filter: filter)) {
    _transactionsSubscription =
        _transactionsRepository.transactions.listen((_) {
      _onSomethingChanged();
    });
    _transfersSubscription =
        _transactionsRepository.getTransfers().skip(1).listen((_) {
      _onSomethingChanged();
    });
  }

  Future<void> _onSomethingChanged() async {
    var trTiles = <TransactionTile>[];

    final transactions = await _transactionsRepository.transactions.first;
    final transfers = await _transactionsRepository.getTransfers().first;
    final categories = await _categoriesRepository.getCategories().first;
    final subcategories =
        await _subcategoriesRepository.getSubcategories().first;
    final accounts = await _accountsRepository.getAccounts().first;

    transactions.forEach((element) {
      /*final cat = categories.where((c) => element.category!.name == c.id).first;
      final subcategory =
          subcategories.where((sc) => element.subcategory!.name == sc.id).first;
      final acc = accounts.where((a) => element.accountId == a.id).first;*/
      /*trTiles.add(element.toTile(
          account: null, category: nu, subcategory: subcategory));*/
    });

    transfers.forEach((element) {
      final fromAcc =
          accounts.where((a) => element.fromAccountId == a.id).first;
      final toAcc = accounts.where((a) => element.toAccountId == a.id).first;
      trTiles.addAll(element.toTiles(fromAccount: fromAcc, toAccount: toAcc));
    });

    trTiles.sort(
      (a, b) => a.dateTime.compareTo(b.dateTime),
    );
    emit(state.copyWith(
        status: TransactionsStatus.success, transactionList: trTiles));
  }

  Future<void> filterChanged({required TransactionsViewFilter filter}) async {
    emit(state.copyWith(filter: filter));
    _onSomethingChanged();
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
    final transaction = state.lastDeletedTransaction;
    final transfer = state.lastDeletedTransfer;
    if (transaction == null) {
      emit(state.copyWith(lastDeletedTransfer: () => null));
      await _transactionsRepository.createTransfer(transfer!);
    } else {
      emit(state.copyWith(lastDeletedTransaction: () => null));
      await _transactionsRepository.createTransaction(transaction);
    }
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    _transfersSubscription.cancel();
    return super.close();
  }
}
