part of 'sections_cubit.dart';

class SectionsState extends Equatable {
  final DataStatus status;
  final List<SectionSummary> sectionSummaryList;
  final String? errorMessage;

  const SectionsState(
      {this.status = DataStatus.loading, this.sectionSummaryList = const [], this.errorMessage});

  SectionsState copyWith({
    DataStatus? status,
    List<SectionSummary>? sectionSummaryList,
    String? errorMessage,
  }) {
    return SectionsState(
      status: status ?? this.status,
      sectionSummaryList: sectionSummaryList ?? this.sectionSummaryList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, sectionSummaryList];
}
