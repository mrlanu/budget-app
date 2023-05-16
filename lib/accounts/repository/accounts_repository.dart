import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/accounts/repository/models/account_model.dart';
import 'package:http/http.dart' as http;

abstract class AccountsRepository {

  final User user;

  AccountsRepository({required this.user});

  Future<void> deleteAccount(String id);

  Future<List<AccountModel>> getAccounts({required String budgetId, required String categoryId});

  Future<void> saveAccount(AccountModel accountModel);

}

class AccountsRepositoryImpl extends AccountsRepository {
  AccountsRepositoryImpl({required super.user});

  @override
  Future<void> deleteAccount(String id) {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<List<AccountModel>> getAccounts(
      {required String budgetId, required String categoryId}) async {
    var response;

    try {
      final url = 'http://10.0.2.2:8080/api/$budgetId/accounts';

      final token = await user.token;
      response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      print('Accs - ${response.body}');

      final accounts = List<Map<dynamic, dynamic>>.from(
        json.decode(response.body) as List,
      ).map((jsonMap) {
        print('jsonmap: $jsonMap');
        final m = AccountModel.fromJson(Map<String, dynamic>.from(jsonMap));
        print('M: $m');
        return m;
      }).toList();

      return accounts;
    } catch (e) {
      print('ERROR - ${e.toString()}');
      return [];
    }
  }

  @override
  Future<void> saveAccount(AccountModel accountModel) {
    // TODO: implement saveAccount
    throw UnimplementedError();
  }
}

