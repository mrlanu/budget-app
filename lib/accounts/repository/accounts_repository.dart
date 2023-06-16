import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../shared/models/budget.dart';
import '../models/account.dart';

abstract class AccountsRepository {
  final User user;
  final Budget budget;

  AccountsRepository({required this.user, required this.budget});

  Future<void> deleteAccount({required Account account});

  Stream<List<Account>> getAccounts();

  Future<void> saveAccount({required Account account});

  Future<List<Account>> fetchAccounts(
      {required String budgetId, String? categoryId});

  Future<void> fetchAllAccounts();
}

class AccountFailure implements Exception {
  final String message;

  const AccountFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

class AccountsRepositoryImpl extends AccountsRepository {
  static const baseURL = '10.0.2.2:8080';
  final _accountsStreamController =
      BehaviorSubject<List<Account>>.seeded(const []);

  AccountsRepositoryImpl({required super.user, required super.budget});

  @override
  Stream<List<Account>> getAccounts() =>
      _accountsStreamController.asBroadcastStream();

  @override
  Future<List<Account>> fetchAccounts(
      {required String budgetId, String? categoryId}) async {
    var response;

    try {
      final url = Uri.http(baseURL, '/api/accounts',
          {'budgetId': budgetId, 'categoryId': categoryId});

      response = await http.get(url, headers: await _getHeaders());

      final accounts = List<Map<dynamic, dynamic>>.from(
        json.decode(response.body) as List,
      ).map((jsonMap) {
        final m = Account.fromJson(Map<String, dynamic>.from(jsonMap));
        return m;
      }).toList();

      return accounts;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> fetchAllAccounts() async {
    var response;

    final url = Uri.http(
        baseURL, '/api/accounts', {'budgetId': budget.id, 'categoryId': ''});

    response = await http.get(url, headers: await _getHeaders());

    final accounts = List<Map<dynamic, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) {
      final m = Account.fromJson(Map<String, dynamic>.from(jsonMap));
      return m;
    }).toList();

    _accountsStreamController.add(accounts);
  }

  @override
  Future<void> saveAccount({required Account account}) async {
    final url = Uri.http(baseURL, '/api/accounts');

    final response = await http.post(url,
        headers: await _getHeaders(), body: json.encode(account.toJson()));

    final newAcc = Account.fromJson(jsonDecode(response.body));

    final accounts = await fetchAccounts(budgetId: newAcc.budgetId);
    _accountsStreamController.add(accounts);
  }

  @override
  Future<void> deleteAccount({required Account account}) async {
    final url = Uri.http(baseURL, '/api/accounts/${account.id}');

    final resp = await http.delete(url, headers: await _getHeaders());
    if (resp.statusCode != 200) {
      throw AccountFailure(jsonDecode(resp.body)['message']);
    }
    final accounts = await fetchAccounts(budgetId: account.budgetId);
    _accountsStreamController.add(accounts);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await user.token;
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }
}
