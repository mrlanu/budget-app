import 'package:bloc/bloc.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:equatable/equatable.dart';

import '../repository/accounts_repository.dart';
import '../repository/models/account_model.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final AccountsRepository _accountsRepository;

  AccountsCubit({required AccountsRepository accountsRepository})
      : _accountsRepository = accountsRepository,
        super(AccountsState());

  Future<void> fetchAllAccounts({required String budgetId, required String categoryId}) async {
    try {
      final accountList =
          await _accountsRepository.getAccounts(budgetId: budgetId,categoryId: categoryId);
      emit(
          state.copyWith(status: DataStatus.success, accountList: accountList));
    } catch (e) {
      emit(
          state.copyWith(status: DataStatus.error, errorMessage: e.toString()));
    }
  }
}
