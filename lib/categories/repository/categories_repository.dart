import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../constants/api.dart';
import '../models/category.dart';

abstract class CategoriesRepository {
  Stream<List<Category>> getCategories();

  Future<void> fetchAllCategories();

  Future<void> saveCategory({required Category category});

  Future<void> deleteCategory({required Category category});
}

class CategoryFailure implements Exception {
  final String message;

  const CategoryFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}

class CategoriesRepositoryImpl extends CategoriesRepository {
  final _categoriesStreamController =
      BehaviorSubject<List<Category>>.seeded(const []);

  CategoriesRepositoryImpl();

  @override
  Stream<List<Category>> getCategories() =>
      _categoriesStreamController.asBroadcastStream();

  @override
  Future<void> fetchAllCategories() async {
    final url = isTestMode
        ? Uri.http(
            baseURL, '/api/categories', {'budgetId': await getBudgetId()})
        : Uri.https(
            baseURL, '/api/categories', {'budgetId': await getBudgetId()});

    final response = await http.get(url, headers: await getHeaders());

    final result = List<Map<String, dynamic>>.from(
      json.decode(response.body) as List,
    ).map((jsonMap) => Category.fromJson(jsonMap)).toList();
    _categoriesStreamController.add(result);
  }

  @override
  Future<void> saveCategory({required Category category}) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/categories')
        : Uri.https(baseURL, '/api/categories');
    final catResponse = await http.post(url,
        headers: await getHeaders(), body: json.encode(category.toJson()));
    final newCategory = Category.fromJson(jsonDecode(catResponse.body));
    final categories = [..._categoriesStreamController.value];
    categories.add(newCategory);
    _categoriesStreamController.add(categories);
  }

  @override
  Future<void> deleteCategory({required Category category}) async {
    final url = isTestMode
        ? Uri.http(baseURL, '/api/categories/${category.id}')
        : Uri.https(baseURL, '/api/categories/${category.id}');

    final resp = await http.delete(url, headers: await getHeaders());

    if (resp.statusCode != 200) {
      throw CategoryFailure(jsonDecode(resp.body)['message']);
    }
    final categories = [..._categoriesStreamController.value];

    final catIndex = categories.indexWhere((c) => c.id == category.id);
    if (catIndex == -1) {
      //throw TodoNotFoundException();
    } else {
      categories.removeAt(catIndex);
      _categoriesStreamController.add(categories);
    }
  }
}
