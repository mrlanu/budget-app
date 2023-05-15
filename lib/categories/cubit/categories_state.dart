part of 'categories_cubit.dart';

enum CategoriesStatus { initial, loading, success, failure }

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final String section;
  final List<CategorySummary> categorySummaryList;
  final String? errorMessage;

  const CategoriesState(
      {required this.section,
      this.status = CategoriesStatus.loading,
      this.categorySummaryList = const [],
      this.errorMessage});

  CategoriesState copyWith({
    CategoriesStatus? status,
    String? section,
    List<CategorySummary>? categorySummaryList,
    String? errorMessage,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      section: section ?? this.section,
      categorySummaryList: categorySummaryList ?? this.categorySummaryList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, section, categorySummaryList, errorMessage];
}
