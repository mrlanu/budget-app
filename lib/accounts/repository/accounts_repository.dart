import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../constants/api.dart';
import '../models/account.dart';

abstract class AccountsRepository {
  Stream<List<Account>> getAccounts();

  Future<void> fetchAllAccounts();

  Future<void> saveAccount({required Account account});

  Future<void> deleteAccount({required Account account});
}

class AccountFailure implements Exception {
  final String message;

  const AccountFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

class AccountsRepositoryImpl extends AccountsRepository {
  final _accountsStreamController =
      BehaviorSubject<List<Account>>.seeded(const []);

  AccountsRepositoryImpl();

  @override
  Stream<List<Account>> getAccounts() =>
      _accountsStreamController.asBroadcastStream();

  @override
  Future<void> fetchAllAccounts() async {
    var response;

    final url = isTestMode
        ? Uri.http(baseURL, '/api/accounts', {'budgetId': await getBudgetId()})
        : Uri.https(
            baseURL, '/api/accounts', {'budgetId': await getBudgetId()});

    response = await http.get(url, headers: await getHeaders());

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
    final url = isTestMode
        ? Uri.http(baseURL, '/api/accounts')
        : Uri.https(baseURL, '/api/accounts');

    final response = await http.post(url,
        headers: await getHeaders(), body: json.encode(account.toJson()));

    final newAcc = Account.fromJson(jsonDecode(response.body));
    final accounts = [..._accountsStreamController.value];
    final accIndex = accounts.indexWhere((acc) => acc.id == newAcc.id);
    if (accIndex == -1) {
      accounts.add(newAcc);
      _accountsStreamController.add(accounts);
    } else {
      accounts.removeAt(accIndex);
      accounts.insert(accIndex, account);
      _accountsStreamController.add(accounts);
    }
  }

  @override
  Future<void> deleteAccount({required Account account}) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/accounts/${account.id}')
        : Uri.https(baseURL, '/api/accounts/${account.id}');

    final resp = await http.delete(url, headers: await getHeaders());
    if (resp.statusCode != 200) {
      throw AccountFailure(jsonDecode(resp.body)['message']);
    }
    final accounts = [..._accountsStreamController.value];
    final accIndex = accounts.indexWhere((acc) => acc.id == account.id);
    if (accIndex == -1) {
      //throw TodoNotFoundException();
    } else {
      accounts.removeAt(accIndex);
      _accountsStreamController.add(accounts);
    }
  }
}
