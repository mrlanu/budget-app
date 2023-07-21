import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/constants/api.dart';
import 'package:budget_app/transactions/models/transaction_tile.dart';
import 'package:budget_app/transactions/repository/transactions_repository.dart';
import 'package:budget_app/transfer/transfer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../accounts/models/account.dart';
import '../../accounts/repository/accounts_repository.dart';
import '../../categories/models/category.dart';
import '../../categories/repository/categories_repository.dart';
import '../../constants/constants.dart';
import '../../transactions/models/transaction_type.dart';

part 'transfer_event.dart';

part 'transfer_state.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransactionsRepository _transactionsRepository;
  final CategoriesRepository _categoriesRepository;
  late final AccountsRepository _accountsRepository;
  late final StreamSubscription<List<Account>> _accountsSubscription;
  late final StreamSubscription<List<Category>> _categoriesSubscription;

  TransferBloc(
      {required TransactionsRepository transactionsRepository,
      required CategoriesRepository categoriesRepository,
      required AccountsRepository accountsRepository})
      : _transactionsRepository = transactionsRepository,
        _categoriesRepository = categoriesRepository,
        _accountsRepository = accountsRepository,
        super(TransferState()) {
    on<TransferEvent>(_onEvent, transformer: sequential());
    _accountsSubscription =
        _accountsRepository.getAccounts().skip(1).listen((accounts) {
      add(TransferAccountsChanged(accounts: accounts));
    });
    _categoriesSubscription =
        _categoriesRepository.getCategories().skip(1).listen((categories) {
      add(TransferCategoriesChanged(categories: categories));
    });
  }

  Future<void> _onEvent(
      TransferEvent event, Emitter<TransferState> emit) async {
    return switch (event) {
      final TransferFormLoaded e => _onFormLoaded(e, emit),
      final TransferAmountChanged e => _onAmountChanged(e, emit),
      final TransferDateChanged e => _onDateChanged(e, emit),
      final TransferAccountsChanged e => _onAccountsChanged(e, emit),
      final TransferFromAccountChanged e => _onFromAccountChanged(e, emit),
      final TransferToAccountChanged e => _onToAccountChanged(e, emit),
      final TransferNotesChanged e => _onNotesChanged(e, emit),
      final TransferCategoriesChanged e => _onCategoriesChanged(e, emit),
      final TransferFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
      TransferFormLoaded event, Emitter<TransferState> emit) async {
    emit(state.copyWith(trStatus: TransferStatus.loading));
    final accounts = await _accountsRepository.getAccounts().first;
    final accCategories = await _categoriesRepository.getCategories().first;
    final filteredCategories = accCategories
        .where((aC) => aC.transactionType == TransactionType.ACCOUNT)
        .toList();
    final transactionTile = event.transactionTile;
    var id;
    var fromAccount;
    var toAccount;
    if (transactionTile != null) {
      id = transactionTile.id;
      fromAccount = accounts
          .where((acc) => acc.id == transactionTile.fromAccount!.id)
          .first;
      toAccount = accounts
          .where((acc) => acc.id == transactionTile.toAccount!.id)
          .first;
    }
    await Future.delayed(Duration(milliseconds: 100));
    emit(state.copyWith(
      budgetId: await getBudgetId(),
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
      accounts: accounts,
      isValid: transactionTile == null ? false : true,
    ));
  }

  void _onCategoriesChanged(
      TransferCategoriesChanged event, Emitter<TransferState> emit) {
    emit(state.copyWith(accountCategories: event.categories));
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
      budgetId: state.budgetId!,
      amount: double.parse(state.amount.value),
      date: state.date ?? DateTime.now(),
      fromAccountId: state.fromAccount!.id!,
      toAccountId: state.toAccount!.id!,
      notes: state.notes,
    );
    try {
      if (state.id == null) {
        await _transactionsRepository.createTransfer(transfer);
      } else {
        await _transactionsRepository.editTransfer(transfer);
      }
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
