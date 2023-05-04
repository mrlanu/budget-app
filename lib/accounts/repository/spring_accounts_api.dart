import 'dart:convert';

import 'package:budget_app/accounts/repository/accounts_repository.dart';
import 'package:budget_app/accounts/repository/models/account_model.dart';
import 'package:http/http.dart' as http;

class SpringAccountsApi extends AccountsRepository {

  SpringAccountsApi({required super.user});

  @override
  Future<void> deleteAccount(String id) {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<List<AccountModel>> getAccounts() async {
    var response;

    try {
      final url = 'http://10.0.2.2:8080/api/accounts';

      final token = await user.token;
      response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
          "Bearer $token"});

      final accounts = List<Map<dynamic, dynamic>>.from(
        json.decode(response.body) as List,
      ).map((jsonMap) => AccountModel.fromJson(Map<String, dynamic>.from(jsonMap))).toList();

      return accounts;
    } catch (e) {
      print('ERROR - ${response.statusCode}');
      return [];
    }
  }

  @override
  Future<void> saveAccount(AccountModel accountModel) {
    // TODO: implement saveAccount
    throw UnimplementedError();
  }
}
