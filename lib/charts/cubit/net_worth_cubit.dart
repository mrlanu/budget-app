import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qruto_budget/charts/models/net_worth_month_point.dart';
import 'package:qruto_budget/charts/repository/chart_repository.dart';

part 'net_worth_state.dart';

class NetWorthCubit extends Cubit<NetWorthState> {
  NetWorthCubit({required ChartRepository chartRepository})
      : _chartRepository = chartRepository,
        super(const NetWorthState());

  final ChartRepository _chartRepository;

  Future<void> load() async {
    emit(state.copyWith(status: NetWorthStatus.loading, clearError: true));
    try {
      final points =
          await _chartRepository.fetchNetWorthMonthlyOpeningBalances(
        includeHiddenAccounts: state.includeHiddenAccounts,
      );
      emit(state.copyWith(
        status: NetWorthStatus.success,
        points: points,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NetWorthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> setIncludeHiddenAccounts(bool includeHidden) async {
    if (state.includeHiddenAccounts == includeHidden) return;
    emit(state.copyWith(includeHiddenAccounts: includeHidden));
    await load();
  }
}
