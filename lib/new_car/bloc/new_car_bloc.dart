import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../new_car_repository.dart';

part 'new_car_event.dart';
part 'new_car_state.dart';

class NewCarBloc extends Bloc<NewCarEvent, NewCarState> {
  NewCarBloc({required NewCarRepository newCarRepository})
      : _newCarRepository = newCarRepository,
        super(const NewCarState.initial()) {
    on<NewCarFormLoaded>(_onNewCarFormLoaded);
    on<NewCarBrandChanged>(_onNewCarBrandChanged);
    on<NewCarModelChanged>(_onNewCarModelChanged);
    on<NewCarYearChanged>(_onNewCarYearChanged);
  }

  final NewCarRepository _newCarRepository;

  Future<void> _onNewCarFormLoaded(
      NewCarFormLoaded event,
      Emitter<NewCarState> emit,
      ) async {
    emit(const NewCarState.brandsLoadInProgress());
    final brands = await _newCarRepository.fetchBrands();
    emit(NewCarState.brandsLoadSuccess(brands: brands));
  }

  Future<void> _onNewCarBrandChanged(
      NewCarBrandChanged event,
      Emitter<NewCarState> emit,
      ) async {
    emit(
      NewCarState.modelsLoadInProgress(
        brands: state.brands,
        brand: event.brand,
      ),
    );
    final models = await _newCarRepository.fetchModels(brand: event.brand);
    emit(
      NewCarState.modelsLoadSuccess(
        brands: state.brands,
        brand: event.brand,
        models: models,
      ),
    );
  }

  Future<void> _onNewCarModelChanged(
      NewCarModelChanged event,
      Emitter<NewCarState> emit,
      ) async {
    emit(
      NewCarState.yearsLoadInProgress(
        brands: state.brands,
        brand: state.brand,
        models: state.models,
        model: event.model,
      ),
    );
    final years = await _newCarRepository.fetchYears(
      brand: state.brand,
      model: event.model,
    );
    emit(
      NewCarState.yearsLoadSuccess(
        brands: state.brands,
        brand: state.brand,
        models: state.models,
        model: event.model,
        years: years,
      ),
    );
  }

  Future<void> _onNewCarYearChanged(
      NewCarYearChanged event,
      Emitter<NewCarState> emit,
      ) async {
    emit(state.copyWith(year: event.year));
  }
}
