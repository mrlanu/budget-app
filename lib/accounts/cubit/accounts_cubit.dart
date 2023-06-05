import 'package:bloc/bloc.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:equatable/equatable.dart';

import '../models/account.dart';
import '../repository/accounts_repository.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final AccountsRepository _accountsRepository;

  AccountsCubit({required AccountsRepository accountsRepository})
      : _accountsRepository = accountsRepository,
        super(AccountsState());

  Future<void> fetchAllAccounts({required String budgetId, required String categoryId}) async {
    try {
      final accountList =
          await _accountsRepository.fetchAccounts(budgetId: budgetId, categoryId: categoryId);
      emit(
          state.copyWith(status: DataStatus.success, accountList: accountList));
    } catch (e) {
      emit(
          state.copyWith(status: DataStatus.error, errorMessage: e.toString()));
    }
  }
}
