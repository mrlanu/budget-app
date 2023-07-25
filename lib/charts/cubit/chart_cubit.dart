import 'package:bloc/bloc.dart';
import 'package:budget_app/charts/models/year_month_sum.dart';
import 'package:budget_app/charts/repository/chart_repository.dart';
import 'package:equatable/equatable.dart';
import 'dart:math';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final ChartRepository _chartRepository;

  ChartCubit({required ChartRepository chartRepository})
      : _chartRepository = chartRepository,
        super(ChartState());

  Future<void> fetchChart() async {
    emit(state.copyWith(status: ChartStatus.loading));
    await Future.delayed(Duration(milliseconds: 200));
    final chartData = await _chartRepository.fetchChart();
    emit(state.copyWith(status: ChartStatus.success, data: chartData));
  }

  void changeTouchedIndex(int index){
    emit(state.copyWith(touchedIndex: index));
  }
}
