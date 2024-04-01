import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/app/repository/budget_repository.dart';
import 'package:budget_app/budgets/budgets.dart';
import 'package:cache_client/cache_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../constants/constants.dart';
import '../../transaction/transaction.dart';

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
    _budgetSubscription = _budgetRepository.budget.listen((budget) {
      add(TransferBudgetChanged(budget: budget));
    });
    on<TransferEvent>(_onEvent, transformer: sequential());
  }

  Future<void> _onEvent(
      TransferEvent event, Emitter<TransferState> emit) async {
    return switch (event) {
      final TransferBudgetChanged e => _onBudgetChanged(e, emit),
      final TransferFormLoaded e => _onFormLoaded(e, emit),
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
    final transaction = event.transaction;
    String? id;
    Account? fromAccount;
    Account? toAccount;
    if (transaction != null) {
      id = transaction.id;
      fromAccount = transaction.fromAccount!;
      toAccount = transaction.toAccount!;
    }
    await Future.delayed(Duration(milliseconds: 100));
    emit(state.copyWith(
      editedTransfer: transaction,
      id: id,
      amount: transaction == null
          ? Amount.pure()
          : Amount.dirty(transaction.amount.toString()),
      trStatus: TransferStatus.success,
      fromAccount: fromAccount,
      toAccount: toAccount,
      date: transaction?.dateTime ?? DateTime.now(),
      notes: transaction?.description ?? '',
      isValid: transaction == null ? false : true,
    ));
  }

  void _onBudgetChanged(
      TransferBudgetChanged event, Emitter<TransferState> emit) {
    emit(state.copyWith(budget: event.budget));
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
    final transfer = Transaction(
      id: state.id,
      type: TransactionType.TRANSFER,
      amount: double.parse(state.amount.value),
      date: state.date ?? DateTime.now(),
      fromAccountId: state.fromAccount!.id,
      toAccountId: state.toAccount!.id,
      description: state.notes,
      budgetId: await CacheClient.instance.getBudgetId() ?? '',
    );
    try {
      await state.editedTransfer == null
          ? _transactionsRepository.createTransaction(transfer)
          : _transactionsRepository.updateTransaction(transfer);
      _updateBudgetOnTransfer(
          transfer: transfer, editedTransfer: state.editedTransfer);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
      isDisplayDesktop(event.context!)
          ? add(TransferFormLoaded())
          : Navigator.of(event.context!).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  void _updateBudgetOnTransfer(
      {required Transaction transfer,
      ComprehensiveTransaction? editedTransfer}) {
    List<Account> updatedAccounts = [];

    final accounts = state.budget.accountList;
    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (editedTransfer != null) {
      updatedAccounts = accounts.map((acc) {
        if (acc.id == editedTransfer.fromAccount!.id) {
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
      if (acc.id == transfer.fromAccountId) {
        return acc.copyWith(balance: acc.balance - transfer.amount);
      } else {
        return acc;
      }
    }).toList();
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transfer.toAccountId) {
        return acc.copyWith(balance: acc.balance + transfer.amount);
      } else {
        return acc;
      }
    }).toList();

    _budgetRepository.pushUpdatedAccounts(updatedAccounts);
  }

  @override
  Future<void> close() {
    _budgetSubscription.cancel();
    return super.close();
  }
}
