import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:equatable/equatable.dart';

import '../../transactions/models/transaction_type.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<Budget> _budgetSubscription;

  AccountsCubit({required BudgetRepository budgetRepository})
      : _budgetRepository = budgetRepository,
        super(AccountsState()) {
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      budgetChanged(budget);
    });
  }

  Future<void> budgetChanged(Budget budget) async {
    emit(state.copyWith(
        status: AccountsStatus.success,
        accountList: budget.accountList,
        accountCategories: budget.categoryList
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
    _budgetSubscription.cancel();
    return super.close();
  }
}
