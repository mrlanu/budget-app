import 'package:bloc/bloc.dart';
import 'package:budget_app/categories/models/category.dart';
import 'package:budget_app/categories/models/subcategory.dart';
import 'package:budget_app/shared/shared.dart';
import 'package:budget_app/transaction/models/transaction.dart';
import 'package:budget_app/transaction/models/transaction_type.dart';
import 'package:equatable/equatable.dart';

import '../../categories/models/section.dart';
import '../../shared/repositories/shared_repository.dart';
import '../repository/transactions_repository.dart';

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
    emit(
      state.copyWith(
        amount: double.parse(value),
      ),
    );
  }

  void dateChanged(DateTime pickedDate) {
    //String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
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

  void accountSelected(Category category) {
    emit(state.copyWith(selectedAccount: category));
  }

  void notesChanged(String notes) {
    emit(state.copyWith(notes: notes));
  }

  Future<void> submit() async {
    final transaction = Transaction(
        budgetId: _sharedRepository.budget!.id,
        date: state.date ?? DateTime.now(),
        type: TransactionType.EXPENSE,
        amount: state.amount.toString(),
        categoryId: state.selectedCategory!.id,
        subcategoryId: state.selectedSubcategory!.id,
        accountId: state.selectedAccount!.id);
    _transactionsRepository.createTransaction(transaction);
  }
}
