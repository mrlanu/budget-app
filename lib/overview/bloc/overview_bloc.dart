import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/repository.dart';

part 'overview_event.dart';

part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final DummyRepository _repository;

  OverviewBloc({required DummyRepository repository})
      : _repository = repository,
        super(OverviewState.loading()) {
    on<LoadCategoriesEvent>(_onLoadCategoriesEvent);
    on<CategoriesLoadedEvent>(_onCategoriesLoadedEvent);
  }

  void _onCategoriesLoadedEvent(
      CategoriesLoadedEvent event, Emitter<OverviewState> emit) {
    emit(OverviewState.loaded(_repository.getMainCategoryList()));
  }

  Future<void> _onLoadCategoriesEvent(
      LoadCategoriesEvent event, Emitter<OverviewState> emit) async {
    emit(OverviewState.loading());
    await Future.delayed(const Duration(milliseconds: 500), () {
      add(CategoriesLoadedEvent());
    },);
  }
}
