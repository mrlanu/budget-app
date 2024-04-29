import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../accounts_list/models/account.dart';
import '../../categories/models/category.dart';
import '../../constants/constants.dart';
import '../../transaction/transaction.dart';

part 'transfer_event.dart';
part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransactionsRepository _transactionsRepository;
  late StreamSubscription<List<Account>> _accountsSubscription;
  late StreamSubscription<List<Category>> _categoriesSubscription;

  TransferBloc({
    required TransactionsRepository transactionsRepository,
  })  : _transactionsRepository = transactionsRepository,
        super(TransferState()) {
    on<TransferEvent>(_onEvent, transformer: sequential());
    _accountsSubscription = _transactionsRepository.accounts.listen((accounts) {
      add(TransferAccountsChanged(accounts: accounts));
    });
    _categoriesSubscription =
        _transactionsRepository.categories.listen((categories) {
      add(TransferCategoriesChanged(categories: categories));
    });
  }

  Future<void> _onEvent(
      TransferEvent event, Emitter<TransferState> emit) async {
    return switch (event) {
      final TransferFormLoaded e => _onFormLoaded(e, emit),
      final TransferAmountChanged e => _onAmountChanged(e, emit),
      final TransferDateChanged e => _onDateChanged(e, emit),
      final TransferFromAccountChanged e => _onFromAccountChanged(e, emit),
      final TransferToAccountChanged e => _onToAccountChanged(e, emit),
      final TransferAccountsChanged e => _onAccountsChanged(e, emit),
      final TransferCategoriesChanged e => _onCategoriesChanged(e, emit),
      final TransferNotesChanged e => _onNotesChanged(e, emit),
      final TransferFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
      TransferFormLoaded event, Emitter<TransferState> emit) async {
    emit(state.copyWith(trStatus: TransferStatus.loading));
    final transaction = event.transaction;
    int? id;
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

  void _onAccountsChanged(
      TransferAccountsChanged event, Emitter<TransferState> emit) {
    emit(state.copyWith(accounts: event.accounts));
  }

  void _onCategoriesChanged(
      TransferCategoriesChanged event, Emitter<TransferState> emit) {
    emit(state.copyWith(categories: event.categories));
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
      description: state.notes,
    )
      ..fromAccount.value = state.fromAccount
      ..toAccount.value = state.toAccount;
    try {
      await state.editedTransfer == null
          ? _transactionsRepository.createTransaction(transfer)
          : _transactionsRepository.updateTransaction(transfer);
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
    _accountsSubscription.cancel();
    _categoriesSubscription.cancel();
    return super.close();
  }
}
