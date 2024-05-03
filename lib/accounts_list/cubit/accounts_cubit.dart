import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/transaction/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/category.dart';
import '../../transaction/models/transaction_type.dart';
import '../models/account.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<List<Account>> _accountsSubscription;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  AccountsCubit({required BudgetRepository budgetRepository})
      : _budgetRepository = budgetRepository,
        super(AccountsState()) {
    _categoriesSubscription =
        _budgetRepository.categories.listen((categories) {
          categoriesChanged(categories);
        });
    _accountsSubscription = _budgetRepository.accounts.listen((accounts) {
      accountsChanged(accounts);
    });
  }

  Future<void> accountsChanged(List<Account> accounts) async {
    emit(state.copyWith(
      status: AccountsStatus.success,
      accountList: accounts,));
    }

  Future<void> categoriesChanged(List<Category> categories) async {
    emit(state.copyWith(
        status: AccountsStatus.success,
        accountCategories: categories
            .where((cat) => cat.type == TransactionType.ACCOUNT)
            .toList()));
  }


  Future<void> onAccountDeleted(int accountId) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    try {
      await _budgetRepository.deleteAccount(accountId: accountId);
    } on AccountFailure catch (e) {
      emit(state.copyWith(
          status: AccountsStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
          status: AccountsStatus.failure, errorMessage: 'Unknown error'));
    }
  }

  @override
  Future<void> close() {
    _accountsSubscription.cancel();
    _categoriesSubscription.cancel();
    return super.close();
  }
}
