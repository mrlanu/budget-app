import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/transaction/repository/budget_repository.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/category.dart';
import '../../transaction/models/transaction_type.dart';
import '../models/account.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final BudgetRepository _transactionsRepository;
  late final StreamSubscription<List<Account>> _accountsSubscription;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  AccountsCubit({required BudgetRepository transactionsRepository})
      : _transactionsRepository = transactionsRepository,
        super(AccountsState()) {
    _categoriesSubscription =
        _transactionsRepository.categories.listen((categories) {
          categoriesChanged(categories);
        });
    _accountsSubscription = _transactionsRepository.accounts.listen((accounts) {
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


  Future<void> onAccountDeleted(Account account) async {
    emit(state.copyWith(status: AccountsStatus.loading));
    /*try {
      await _accountsRepository.deleteAccount(account: account);
    } on AccountFailure catch (e) {
      emit(state.copyWith(
          status: AccountsListStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
          status: AccountsListStatus.failure, errorMessage: 'Unknown error'));
    }*/
  }

  @override
  Future<void> close() {
    _accountsSubscription.cancel();
    _categoriesSubscription.cancel();
    return super.close();
  }
}
