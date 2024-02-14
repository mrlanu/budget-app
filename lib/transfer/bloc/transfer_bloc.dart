import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/constants/api.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transfer/transfer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../constants/constants.dart';

part 'transfer_event.dart';
part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransactionsRepository _transactionsRepository;
  final BudgetRepository _budgetRepository;
  late final StreamSubscription<Budget> _budgetSubscription;

  TransferBloc(
      {required TransactionsRepository transactionsRepository,
      required BudgetRepository budgetRepository})
      : _transactionsRepository = transactionsRepository,
        _budgetRepository = budgetRepository,
        super(TransferState()) {
    on<TransferEvent>(_onEvent, transformer: sequential());
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      add(TransferBudgetChanged(budget: budget));
    });
  }

  Future<void> _onEvent(
      TransferEvent event, Emitter<TransferState> emit) async {
    return switch (event) {
      final TransferBudgetChanged e => _onBudgetChanged(e, emit),
      final TransferFormLoaded e => _onFormLoaded(e, emit),
      final TransferAmountChanged e => _onAmountChanged(e, emit),
      final TransferDateChanged e => _onDateChanged(e, emit),
      final TransferAccountsChanged e => _onAccountsChanged(e, emit),
      final TransferFromAccountChanged e => _onFromAccountChanged(e, emit),
      final TransferToAccountChanged e => _onToAccountChanged(e, emit),
      final TransferNotesChanged e => _onNotesChanged(e, emit),
      final TransferFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
      TransferFormLoaded event, Emitter<TransferState> emit) async {
    emit(state.copyWith(trStatus: TransferStatus.loading));
    final filteredCategories =
        _budgetRepository.getCategoriesByType(TransactionType.ACCOUNT);
    final transactionTile = event.transactionTile;
    String? id;
    Account? fromAccount;
    Account? toAccount;
    if (transactionTile != null) {
      id = transactionTile.id;
      fromAccount =
          _budgetRepository.getAccountById(transactionTile.fromAccount!.id);
      toAccount =
          _budgetRepository.getAccountById(transactionTile.toAccount!.id);
    }
    await Future.delayed(Duration(milliseconds: 100));
    emit(state.copyWith(
      editedTransfer: transactionTile,
      id: id,
      amount: transactionTile == null
          ? Amount.pure()
          : Amount.dirty(transactionTile.amount.toString()),
      trStatus: TransferStatus.success,
      fromAccount: fromAccount,
      toAccount: toAccount,
      date: transactionTile?.dateTime ?? DateTime.now(),
      notes: transactionTile?.description ?? '',
      accountCategories: filteredCategories,
      accounts: _budgetRepository.getAccounts(),
      isValid: transactionTile == null ? false : true,
    ));
  }

  void _onBudgetChanged(
      TransferBudgetChanged event, Emitter<TransferState> emit) {
    emit(state.copyWith(accounts: event.budget.accountList,
        accountCategories: event.budget.categoryList
            .where((cat) => cat.type == TransactionType.ACCOUNT)
            .toList()));
  }

  void _onAmountChanged(
      TransferAmountChanged event, Emitter<TransferState> emit) {
    final amount = Amount.dirty(event.amount!);
    emit(
      state.copyWith(
        amount: amount,
        isValid: Formz.validate([amount]),
      ),
    );
  }

  void _onDateChanged(TransferDateChanged event, Emitter<TransferState> emit) {
    emit(
      state.copyWith(date: event.dateTime),
    );
  }

  void _onAccountsChanged(
      TransferAccountsChanged event, Emitter<TransferState> emit) {
    emit(state.copyWith(accounts: event.accounts));
  }

  void _onFromAccountChanged(
      TransferFromAccountChanged event, Emitter<TransferState> emit) {
    emit(state.copyWith(fromAccount: event.account));
  }

  void _onToAccountChanged(
      TransferToAccountChanged event, Emitter<TransferState> emit) {
    emit(state.copyWith(toAccount: event.account));
  }

  void _onNotesChanged(
      TransferNotesChanged event, Emitter<TransferState> emit) {
    emit(state.copyWith(notes: event.notes));
  }

  Future<void> _onFormSubmitted(
      TransferFormSubmitted event, Emitter<TransferState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final transfer = Transfer(
      id: state.id,
      amount: double.parse(state.amount.value),
      date: state.date ?? DateTime.now(),
      fromAccountId: state.fromAccount!.id,
      toAccountId: state.toAccount!.id,
      notes: state.notes, budgetId: await getCurrentBudgetId(),
    );
    try {
      await _transactionsRepository.saveTransfer(
          transfer: transfer,
          budget: await _budgetRepository.budget.first,
          editedTransaction: state.editedTransfer);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      isDisplayDesktop(event.context!)
          ? add(TransferFormLoaded())
          : Navigator.of(event.context!).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _budgetSubscription.cancel();
    return super.close();
  }
}
