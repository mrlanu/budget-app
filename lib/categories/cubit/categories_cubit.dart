import 'package:bloc/bloc.dart';
import 'package:budget_app/categories/models/category_summary.dart';
import 'package:budget_app/shared/repositories/shared_repository.dart';
import 'package:equatable/equatable.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final SharedRepository sharedRepository;

  CategoriesCubit({required this.sharedRepository, required String section})
      : super(CategoriesState(section: section));

  Future<void> subscriptionRequested() async {
    emit(state.copyWith(status: CategoriesStatus.loading));
    await sharedRepository.getCategorySummary().listen(
        (summary) => emit(state.copyWith(
              status: CategoriesStatus.success,
              categorySummaryList: summary,
            )),
        onError: (e, __) => emit(state.copyWith(
            status: CategoriesStatus.failure, errorMessage: e.toString())));
  }
}
