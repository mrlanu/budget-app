import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:equatable/equatable.dart';

part 'accounts_list_state.dart';

class AccountsListCubit extends Cubit<AccountsListState> {
  late final BudgetRepository _budgetRepository;
  late final StreamSubscription<Budget> _budgetSubscription;

  AccountsListCubit({required BudgetRepository budgetRepository})
      : _budgetRepository = budgetRepository,
        super(AccountsListState()) {
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      _onBudgetChanged(budget);
    });
  }

  void _onBudgetChanged(Budget budget) {
    emit(state.copyWith(
        accounts: budget.accountList,
        accountCategories:
            _budgetRepository.getCategoriesByType(TransactionType.ACCOUNT)));
  }

  Future<void> _onCategoriesChanged(categories) async {
    final filteredCategories = categories
        .where((cat) => cat.transactionType == TransactionType.ACCOUNT)
        .toList();
    emit(state.copyWith(accountCategories: filteredCategories));
  }

  Future<void> onAccountDeleted(Account account) async {
    emit(state.copyWith(status: AccountsListStatus.loading));
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
    _budgetSubscription.cancel();
    return super.close();
  }
}
