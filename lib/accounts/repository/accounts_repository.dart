import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../models/account.dart';

abstract class AccountsRepository {

  final User user;

  AccountsRepository({required this.user});

  Future<void> deleteAccount({required String accountId});

  Stream<List<Account>> getAccounts();

  Future<void> saveAccount({required Account account});

  Future<List<Account>> fetchAccounts({required String budgetId});

}

class AccountsRepositoryImpl extends AccountsRepository {

  static const baseURL = '10.0.2.2:8080';
  final _accountsStreamController =
  BehaviorSubject<List<Account>>.seeded(const []);

  AccountsRepositoryImpl({required super.user});

  @override
  Stream<List<Account>> getAccounts() =>
      _accountsStreamController.asBroadcastStream();

  @override
  Future<List<Account>> fetchAccounts({required String budgetId}) async {
    var response;

    try {
      final url = Uri.http(baseURL, '/api/accounts', {'budgetId': budgetId});

      response = await http.get(url, headers: await _getHeaders());

      final accounts = List<Map<dynamic, dynamic>>.from(
        json.decode(response.body) as List,
      ).map((jsonMap) {
        final m = Account.fromJson(Map<String, dynamic>.from(jsonMap));
        return m;
      }).toList();
      
      return accounts;
    } catch (e) {
      print('E R O R from Acc');
      return [];
    }
  }

  @override
  Future<void> saveAccount({required Account account}) async {
    final url = Uri.http(baseURL, '/api/accounts');

    final response = await http.post(url,
        headers: await _getHeaders(), body: json.encode(account.toJson()));

    final newAcc = Account.fromJson(jsonDecode(response.body));
    final accounts = [..._accountsStreamController.value];

    accounts.removeWhere((element) => element.id == account.id);
    accounts.add(newAcc);
    _accountsStreamController.add(accounts);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await user.token;
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }

  @override
  Future<void> deleteAccount({required String accountId}) async {
    final url = Uri.http(baseURL, '/api/accounts/$accountId');

    await http.delete(url, headers: await _getHeaders());
    final accounts = [..._accountsStreamController.value];
    final index = accounts.indexWhere((element) => element.id == accountId);
    accounts.removeAt(index);
    _accountsStreamController.add(accounts);
  }
}

