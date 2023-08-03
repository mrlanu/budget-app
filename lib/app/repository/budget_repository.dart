import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/api.dart';

abstract class BudgetRepository {
  Future<void> fetchBudget();
}

class BudgetRepositoryImpl extends BudgetRepository {

  @override
  Future<void> fetchBudget() async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/budgets')
        : Uri.https(baseURL, '/api/budgets');

    final response = await http.get(url, headers: await getHeaders());
    await _setValue('budget', response.body);
  }

  Future<void> _setValue(String key, String value) async {
    final _plugin = await SharedPreferences.getInstance();
      _plugin.setString(key, value);}
}
