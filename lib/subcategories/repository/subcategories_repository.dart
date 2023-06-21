import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:budget_app/shared/models/budget.dart';
import 'package:rxdart/rxdart.dart';

import '../../categories/repository/categories_repository.dart';
import '../../shared/models/subcategory.dart';
import 'package:http/http.dart' as http;

abstract class SubcategoriesRepository {
  final User user;
  final Budget budget;

  const SubcategoriesRepository({required this.user, required this.budget});

  Stream<List<Subcategory>> getSubcategories();

  Future<void> saveSubcategory(
      {required String budgetId, required Subcategory subcategory});

  Future<void> fetchSubcategories();

  Future<void> delete({required Subcategory subcategory});
}

class SubcategoriesRepositoryImpl extends SubcategoriesRepository {
  static const baseURL = '10.0.2.2:8080';

  SubcategoriesRepositoryImpl({required super.user, required super.budget});

  final _subcategoriesStreamController =
      BehaviorSubject<List<Subcategory>>.seeded(const []);

  @override
  Stream<List<Subcategory>> getSubcategories() =>
      _subcategoriesStreamController.asBroadcastStream();

  @override
  Future<void> saveSubcategory(
      {required String budgetId, required Subcategory subcategory}) async {
    final url = Uri.http(baseURL, '/api/subcategories');

    final response = await http.post(url,
        headers: await _getHeaders(), body: json.encode(subcategory.toJson()));

    final newSubcategory = Subcategory.fromJson(jsonDecode(response.body));
    final subcategories = [..._subcategoriesStreamController.value];
    subcategories.add(newSubcategory);
    _subcategoriesStreamController.add(subcategories);
  }

  @override
  Future<void> fetchSubcategories() async {
    final url =
        Uri.http(baseURL, '/api/subcategories', {'budgetId': budget.id});
    final response = await http.get(url, headers: await _getHeaders());

    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
            Subcategory.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

   _subcategoriesStreamController.add(result);
  }

  @override
  Future<void> delete({required Subcategory subcategory}) async {
    final url = Uri.http(baseURL, '/api/subcategories/${subcategory.id}');

    final resp = await http.delete(url, headers: await _getHeaders());

    if(resp.statusCode !=200){
      throw CategoryFailure(jsonDecode(resp.body)['message']);
    }

    final subcategories = [..._subcategoriesStreamController.value];
    final subIndex = subcategories.indexWhere((t) => t.id == subcategory.id);
    if (subIndex == -1) {
      //throw TodoNotFoundException();
    } else {
      subcategories.removeAt(subIndex);
      _subcategoriesStreamController.add(subcategories);
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await user.token;
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
  }
}
