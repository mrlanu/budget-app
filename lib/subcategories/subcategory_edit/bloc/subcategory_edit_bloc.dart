import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:budget_app/transaction/repository/transactions_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:isar/isar.dart';

import '../../../categories/models/category.dart';
import '../../models/subcategory.dart';

part 'subcategory_edit_event.dart';
part 'subcategory_edit_state.dart';

class SubcategoryEditBloc
    extends Bloc<SubcategoryEditEvent, SubcategoryEditState> {
  final TransactionsRepository _transactionsRepository;
  late final StreamSubscription<List<Subcategory>> _subcategoriesSubscription;

  SubcategoryEditBloc({required TransactionsRepository transactionsRepository})
      : _transactionsRepository = transactionsRepository,
        super(SubcategoryEditState()) {
    on<SubcategoryEditEvent>(_onEvent, transformer: sequential());
    _subcategoriesSubscription = _transactionsRepository.subcategories.listen((subcategories) {
      add(SubcategorySubcategoriesChanged(subcategories: subcategories));
    });
  }

  Future<void> _onEvent(
      SubcategoryEditEvent event, Emitter<SubcategoryEditState> emit) async {
    return switch (event) {
      final SubcategorySubcategoriesChanged e => _onSubcategoriesChanged(e, emit),
      final SubcategoryEditFormLoaded e => _onFormLoaded(e, emit),
      final SubcategoryNameChanged e => _onNameChanged(e, emit),
      final SubcategoryFormSubmitted e => _onFormSubmitted(e, emit),
    };
  }

  Future<void> _onFormLoaded(
      SubcategoryEditFormLoaded event, Emitter<SubcategoryEditState> emit) async {
    if (event.subcategory != null) {
      Subcategory subcategory = event.subcategory!;
      emit(state.copyWith(
          category: event.category,
          id: subcategory.id,
          name: subcategory.name,
          isValid: true));
    } else {
      emit(state.copyWith(
          category: event.category, catStatus: SubcategoryEditStatus.success));
    }
  }

  void _onNameChanged(
      SubcategoryNameChanged event, Emitter<SubcategoryEditState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onSubcategoriesChanged(
      SubcategorySubcategoriesChanged event, Emitter<SubcategoryEditState> emit) {
    emit(state.copyWith());
  }

  Future<void> _onFormSubmitted(
      SubcategoryFormSubmitted event, Emitter<SubcategoryEditState> emit) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final isIdExist = state.id != null;
    final subcategory = Subcategory(
      id: isIdExist ? state.id! : Isar.autoIncrement,
      name: state.name!,
    );
    isIdExist
        ? _transactionsRepository.updateSubcategory(state.category!, subcategory)
        : _transactionsRepository.createSubcategory(state.category!, subcategory);
  }

  @override
  Future<void> close() {
    _subcategoriesSubscription.cancel();
    return super.close();
  }
}
