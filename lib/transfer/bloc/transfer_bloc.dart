import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/database/database.dart';
import 'package:budget_app/database/transaction_with_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../accounts_list/account_edit/model/account_with_details.dart';
import '../../accounts_list/repository/account_repository.dart';
import '../../transaction/transaction.dart';

part 'transfer_event.dart';
part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransactionRepository _transactionsRepository;
  final AccountRepository _accountsRepository;
  late final StreamSubscription<List<AccountWithDetails>> _accountsSubscription;

  TransferBloc(
      {required TransactionRepository transactionsRepository,
      required AccountRepository accountRepository})
      : _transactionsRepository = transactionsRepository,
        _accountsRepository = accountRepository,
        super(TransferState(date: DateTime.now())) {
    _accountsSubscription = _accountsRepository.accounts.listen((accounts) {
      add(TransferAccountsChanged(accounts: accounts));
    });
    on<TransferEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(
      TransferEvent event, Emitter<TransferState> emit) async {
    return switch (event) {
      final TransferFormLoaded e => _onFormLoaded(e, emit),
      final TransferAccountsChanged e => _onAccountsChanged(e, emit),
      final TransferAmountChanged e => _onAmountChanged(e, emit),
      final TransferDateChanged e => _onDateChanged(e, emit),
      final TransferFromAccountChanged e => _onFromAccountChanged(e, emit),
      final TransferToAccountChanged e => _onToAccountChanged(e, emit),
      final TransferNotesChanged e => _onNotesChanged(e, emit),
      final TransferFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
      TransferFormLoaded event, Emitter<TransferState> emit) async {
    emit(state.copyWith(trStatus: TransferStatus.loading));
    if (event.transactionId != null) {
      final editedTransaction = await _transactionsRepository
          .getTransactionById(event.transactionId!);
      final fromAccount = await _accountsRepository
          .getAccountById(editedTransaction.fromAccount.id);
      final toAccount = await _accountsRepository
          .getAccountById(editedTransaction.toAccount!.id);

      emit(state.copyWith(
        editedTransfer: editedTransaction,
        id: editedTransaction.id,
        amount: Amount.dirty(editedTransaction.amount.toString()),
        trStatus: TransferStatus.success,
        fromAccount: fromAccount,
        toAccount: toAccount,
        date: editedTransaction.date,
        notes: editedTransaction.description,
        isValid: true,
      ));
    } else {
      emit(state.copyWith(
        trStatus: TransferStatus.success,
      ));
    }
  }

  Future<void> _onAccountsChanged(
    TransferAccountsChanged event,
    Emitter<TransferState> emit,
  ) async {
    emit(state.copyWith(accounts: event.accounts));
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
    try {
      final isIdExist = state.id != null;
      int transactionId;
      if (isIdExist) {
        await _transactionsRepository.updateTransaction(
            id: state.id!,
            date: state.date!,
            type: TransactionType.TRANSFER,
            amount: double.parse(state.amount.value),
            fromAccountId: state.fromAccount!.id!,
            toAccountId: state.toAccount!.id!,
            description: state.notes);
        transactionId = state.id!;
      } else {
        transactionId = await _transactionsRepository.insertTransaction(
            date: state.date!,
            type: TransactionType.TRANSFER,
            amount: double.parse(state.amount.value),
            fromAccountId: state.fromAccount!.id!,
            toAccountId: state.toAccount!.id!,
            description: state.notes);
      }
      final newTransaction =
          await _transactionsRepository.getTransactionById(transactionId);
      _updateBudgetOnTransfer(
          editedTransfer: state.editedTransfer, newTransfer: newTransaction);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      Navigator.of(event.context!).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void _updateBudgetOnTransfer(
      {TransactionWithDetails? editedTransfer,
      required TransactionWithDetails newTransfer}) async {
    List<Account> updatedAccounts = [];
    final accounts = await _accountsRepository.getAllAccounts();
    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (editedTransfer != null) {
      updatedAccounts = accounts.map((acc) {
        if (acc.id == editedTransfer.fromAccount.id) {
          return acc.copyWith(balance: acc.balance + editedTransfer.amount);
        } else {
          return acc;
        }
      }).toList();
      updatedAccounts = updatedAccounts.map((acc) {
        if (acc.id == editedTransfer.toAccount!.id) {
          return acc.copyWith(balance: acc.balance - editedTransfer.amount);
        } else {
          return acc;
        }
      }).toList();
    } else {
      updatedAccounts = [...accounts];
    }

    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == newTransfer.fromAccount.id) {
        return acc.copyWith(balance: acc.balance - newTransfer.amount);
      } else {
        return acc;
      }
    }).toList();
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == newTransfer.toAccount!.id) {
        return acc.copyWith(balance: acc.balance + newTransfer.amount);
      } else {
        return acc;
      }
    }).toList();

    updatedAccounts.forEach(
          (acc) => _accountsRepository.updateAccount(
          id: acc.id,
          name: acc.name,
          includeInTotal: acc.includeInTotal,
          balance: acc.balance,
          initialBalance: acc.initialBalance,
          currency: acc.currency ?? '',
          categoryId: acc.categoryId),
    );
  }

  @override
  Future<void> close() {
    _accountsSubscription.cancel();
    return super.close();
  }
}
