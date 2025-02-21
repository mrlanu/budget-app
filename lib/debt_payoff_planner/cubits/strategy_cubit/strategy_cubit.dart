import 'package:bloc/bloc.dart';
import 'package:budget_app/debt_payoff_planner/models/debt_payoff_strategy.dart';
import 'package:cache/cache.dart';
import 'package:equatable/equatable.dart';
import 'package:network/network.dart';

part 'strategy_state.dart';

class StrategyCubit extends Cubit<StrategyState> {
  StrategyCubit() : super(LoadingStrategyState());

  Future<void> fetchStrategy(
      {String extraPayment = '0', String strategyName = 'snowball'}) async {
    emit(LoadingStrategyState());
    try {
      final response = await NetworkClient.instance.get<Map<String, dynamic>>(
          'baseURL' + '/api/debts/payoff',
          queryParameters: {
            'budgetId': await Cache.instance.getBudgetId(),
            'extraPayment': extraPayment,
            'strategy': strategyName,
          });
      final strategy = DebtPayoffStrategy.fromJson(response.data!);
      emit(LoadedStrategyState(
          strategy: strategyName,
          extraPayment: extraPayment,
          debtPayoffStrategy: strategy));
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    }
  }
}
