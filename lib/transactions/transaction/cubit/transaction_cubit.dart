import 'package:bloc/bloc.dart';
import 'package:budget_app/accounts/models/account_brief.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/categories/models/subcategory.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '../../../categories/models/section.dart';
import '../../../shared/repositories/shared_repository.dart';
import '../../repository/transactions_repository.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final SharedRepository _sharedRepository;
  final TransactionsRepository _transactionsRepository;

  TransactionCubit(SharedRepository sharedRepository,
      TransactionsRepository transactionsRepository)
      : this._sharedRepository = sharedRepository,
        this._transactionsRepository = transactionsRepository,
        super(TransactionState()) {
    final categories = _sharedRepository.budget?.categoryList
        .where((cat) => cat.section == Section.EXPENSES)
        .toList();
    emit(state.copyWith(categories: categories));
  }

  void amountChanged(String value) {
    final amount = Amount.dirty(value);
    emit(
      state.copyWith(
        amount: amount,
        status: Formz.validate([amount]),
      ),
    );
  }

  void dateChanged(DateTime pickedDate) {
    /*String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);*/
    emit(
      state.copyWith(date: pickedDate),
    );
  }

  void categorySelected(Category category) {
    final subcategories = _sharedRepository.budget?.subcategoryList
        .where((cat) => cat.categoryId == category.id)
        .toList();
    emit(state.copyWithResetSubcategory(
        selectedCategory: category, subcategories: subcategories));
  }

  void subcategorySelected(Subcategory subcategory) {
    emit(state.copyWith(selectedSubcategory: subcategory));
  }

  void accountSelected(AccountBrief accountBrief) {
    emit(state.copyWith(selectedAccount: accountBrief));
  }

  void notesChanged(String notes) {
    emit(state.copyWith(notes: notes));
  }

  Future<void> submit(BuildContext context) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final transaction = Transaction(
        id: '',
        budgetId: _sharedRepository.budget!.id,
        date: state.date ?? DateTime.now(),
        type: TransactionType.EXPENSE,
        amount: state.amount.value,
        categoryId: state.selectedCategory!.id,
        subcategoryId: state.selectedSubcategory!.id,
        accountId: state.selectedAccount!.id,);
    try {
      await _transactionsRepository.createTransaction(transaction);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      Navigator.of(context).pop();
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
