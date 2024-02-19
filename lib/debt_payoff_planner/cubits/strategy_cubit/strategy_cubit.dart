import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:budget_app/debt_payoff_planner/models/debt_payoff_strategy.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../../constants/api.dart';

part 'strategy_state.dart';

class StrategyCubit extends Cubit<StrategyState> {
  StrategyCubit() : super(LoadingStrategyState());

  Future<void> fetchStrategy(
      {String extraPayment = '0', String strategyName = 'snowball'}) async {
    emit(LoadingStrategyState());
    final url = isTestMode
        ? Uri.http(baseURL, '/api/debts/payoff', {
            'budgetId': await getCurrentBudgetId(),
            'extraPayment': extraPayment,
            'strategy': strategyName,
          })
        : Uri.https(baseURL, '/api/debts/payoff', {
            'budgetId': await getCurrentBudgetId(),
            'extraPayment': extraPayment,
            'strategy': strategyName,
          });

    final response = await http.get(url, headers: await getHeaders());
    final strategy = DebtPayoffStrategy.fromJson(jsonDecode(response.body));
    emit(LoadedStrategyState(
        strategy: strategyName,
        extraPayment: extraPayment,
        debtPayoffStrategy: strategy));
  }
}
