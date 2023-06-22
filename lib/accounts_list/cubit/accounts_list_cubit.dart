import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/models/account.dart';
import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/categories/repository/categories_repository.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/category.dart';

part 'accounts_list_state.dart';

class AccountsListCubit extends Cubit<AccountsListState> {
  final AccountsRepository _accountsRepository;
  final CategoriesRepository _categoriesRepository;
  late final StreamSubscription<List<Account>> _accountsSubscription;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  AccountsListCubit(
      {required AccountsRepository accountsRepository,
      required CategoriesRepository categoriesRepository})
      : _accountsRepository = accountsRepository,
        _categoriesRepository = categoriesRepository,
        super(AccountsListState()) {
    _accountsSubscription =
        _accountsRepository.getAccounts().listen((accounts) {
      _onAccountsChanged(accounts);
    });
    _categoriesSubscription =
        _categoriesRepository.getCategories().listen((categories) {
      _onCategoriesChanged(categories);
    });
  }

  Future<void> onInit({required String budgetId}) async {
    emit(state.copyWith(status: AccountsListStatus.loading));
    final accounts = await _accountsRepository.getAccounts().first;
    final categories = await _categoriesRepository.getCategories().first;
    final filteredCategories = categories
        .where((cat) => cat.transactionType == TransactionType.ACCOUNT)
        .toList();
    emit(state.copyWith(
        status: AccountsListStatus.success,
        accounts: accounts,
        accountCategories: filteredCategories));
  }

  void _onAccountsChanged(List<Account> accounts) {
    emit(state.copyWith(accounts: accounts));
  }

  Future<void> _onCategoriesChanged(categories) async {
    final filteredCategories = categories
        .where((cat) => cat.transactionType == TransactionType.ACCOUNT)
        .toList();
    emit(state.copyWith(accountCategories: filteredCategories));
  }

  Future<void> onAccountDeleted(Account account) async {
    emit(state.copyWith(status: AccountsListStatus.loading));
    try {
      await _accountsRepository.deleteAccount(account: account);
    } on AccountFailure catch (e) {
      emit(state.copyWith(
          status: AccountsListStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
          status: AccountsListStatus.failure, errorMessage: 'Unknown error'));
    }
  }

  @override
  Future<void> close() {
    _accountsSubscription.cancel();
    _categoriesSubscription.cancel();
    return super.close();
  }
}
