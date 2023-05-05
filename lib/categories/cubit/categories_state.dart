part of 'categories_cubit.dart';

class CategoriesState extends Equatable {

  final DataStatus status;
  final List<CategorySummary> categorySummaryList;
  final String? errorMessage;

  const CategoriesState({this.status = DataStatus.loading, this.categorySummaryList = const [], this.errorMessage});

  CategoriesState copyWith({
    DataStatus? status,
    List<CategorySummary>? categorySummaryList,
    String? errorMessage,
  }) {
    return CategoriesState(
      status: status ?? this.status,
      categorySummaryList: categorySummaryList ?? this.categorySummaryList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [];
}
