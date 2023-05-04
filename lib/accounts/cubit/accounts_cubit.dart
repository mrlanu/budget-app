import 'package:bloc/bloc.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:equatable/equatable.dart';

import '../repository/accounts_repository.dart';
import '../repository/models/account_model.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final AccountsRepository _accountsRepository;

  AccountsCubit(this._accountsRepository) : super(AccountsState());

  Future<void> fetchAllAccounts() async {
    try {
      final accountList = await _accountsRepository.getAccounts();
      emit(
          state.copyWith(status: DataStatus.success, accountList: accountList));
    } catch (e) {
      emit(
          state.copyWith(status: DataStatus.error, errorMessage: e.toString()));
    }
  }
}
