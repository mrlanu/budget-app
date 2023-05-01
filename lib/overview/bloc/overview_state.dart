part of 'overview_bloc.dart';

enum OverviewStatus {
  loading,
  loaded,
}

class OverviewState extends Equatable {
  final OverviewStatus status;
  final List<MainCategoryData> categoryList;

  const OverviewState._({required this.status, this.categoryList = const []});

  const OverviewState.loading() : this._(status: OverviewStatus.loading);

  const OverviewState.loaded(List<MainCategoryData> data)
      : this._(categoryList: data, status: OverviewStatus.loaded);

  @override
  List<Object> get props => [status, categoryList];
}
