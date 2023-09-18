import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/models/accounts_view_filter.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:equatable/equatable.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<List<Transaction>> _transactionsSubscription;
  late final StreamSubscription<Budget> _budgetSubscription;

  AccountsCubit(
      {required AccountsViewFilter filter, required BudgetRepository budgetRepository})
      : _budgetRepository = budgetRepository,
        super(AccountsState(filter: filter)) {
    _budgetSubscription = _budgetRepository
        .budget
        .listen((budget) {
      budgetChanged(budget);
    });
  }

  Future<void> budgetChanged(Budget budget) async {
    emit(
        state.copyWith(status: DataStatus.success, accountList: budget.accountList));
  }

  Future<void> changeExpanded(int index)async{
    var accounts = [...state.accountList];
    accounts[index] = accounts[index].copyWith(isExpanded: !accounts[index].isExpanded);
    emit(state.copyWith(accountList: accounts));
  }

  @override
  Future<void> close() {
    _transactionsSubscription.cancel();
    _budgetSubscription.cancel();
    return super.close();
  }
}
