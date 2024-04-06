import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  Cache._(){
    SharedPreferences.setMockInitialValues({});
  }

  static final Cache _instance = Cache._();
  static Cache get instance => _instance;

  final _key = 'authToken';
  final _keyBudgetId = 'budgetId';
  final _keyName = 'name';

  Future<void> setAccessToken({required String accessToken}) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_key, accessToken);
  }

  Future<String?> getAccessToken() async {
    final _prefs = await SharedPreferences.getInstance();
    final accessToken = _prefs.getString(_key);
    return accessToken;
  }

  Future<void> deleteAccessToken() async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.remove(_key);
  }

  Future<void> setBudgetId({required String budgetId}) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_keyBudgetId, budgetId);
  }

  Future<String?> getBudgetId() async {
    final _prefs = await SharedPreferences.getInstance();
    final budgetId = _prefs.getString(_keyBudgetId);
    return budgetId;
  }

  Future<void> setUsername({required String name}) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_keyName, name);
  }

  Future<String?> getUsername() async {
    final _prefs = await SharedPreferences.getInstance();
    final username = _prefs.getString(_keyName);
    return username;
  }
}
