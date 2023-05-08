import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../shared/repositories/shared_repository.dart';
import '../../shared/shared.dart';
import '../models/section_summary.dart';

part 'sections_state.dart';

class SectionsCubit extends Cubit<SectionsState> {

  final SharedRepository _sharedRepository;

  SectionsCubit(SharedRepository sharedRepository) :
        this._sharedRepository = sharedRepository,
        super(SectionsState());

  Future<void> fetchAllSections() async {
    try {
      final sections = await _sharedRepository.fetchAllSections();
      _sharedRepository.fetchBudget();
      emit(state.copyWith(
          status: DataStatus.success, sectionSummaryList: sections));
    } catch (e) {
      emit(
          state.copyWith(status: DataStatus.error, errorMessage: e.toString()));
    }
  }
}
