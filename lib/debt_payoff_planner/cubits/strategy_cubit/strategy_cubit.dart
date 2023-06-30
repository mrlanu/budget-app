import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:budget_app/debt_payoff_planner/models/debt_payoff_strategy.dart';
import 'package:budget_app/debt_payoff_planner/models/debt_strategy_report.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../../constants/api.dart';

part 'strategy_state.dart';

class StrategyCubit extends Cubit<StrategyState> {
  StrategyCubit() : super(LoadingStrategyState());

  Future<void> fetchStrategy() async {
    emit(LoadingStrategyState());
    final url = Uri.http(baseURL, '/api/debts/payoff',
        {'budgetId': await getBudgetId(), 'extraPayment': '0', 'strategy': 'snowball'});

    final response = await http.get(url, headers: await getHeaders());
    final strategy = DebtPayoffStrategy.fromJson(jsonDecode(response.body));
    emit(LoadedStrategyState(debtPayoffStrategy: strategy));
  }
}
