import 'dart:convert';

import 'package:budget_app/shared/models/budget.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../categories/repository/categories_repository.dart';
import '../../constants/api.dart';
import '../../shared/models/subcategory.dart';

abstract class SubcategoriesRepository {
  Stream<List<Subcategory>> getSubcategories();
  Future<void> saveSubcategory({required Subcategory subcategory});
  Future<void> fetchSubcategories();
  Future<void> delete({required Subcategory subcategory});
}

class SubcategoriesRepositoryImpl extends SubcategoriesRepository {

  SubcategoriesRepositoryImpl();

  final _subcategoriesStreamController =
      BehaviorSubject<List<Subcategory>>.seeded(const []);

  @override
  Stream<List<Subcategory>> getSubcategories() =>
      _subcategoriesStreamController.asBroadcastStream();

  @override
  Future<void> saveSubcategory({required Subcategory subcategory}) async {
    final url = Uri.http(baseURL, '/api/subcategories');

    final response = await http.post(url,
        headers: await getHeaders(), body: json.encode(subcategory.toJson()));

    final newSubcategory = Subcategory.fromJson(jsonDecode(response.body));
    final subcategories = [..._subcategoriesStreamController.value];
    subcategories.add(newSubcategory);
    _subcategoriesStreamController.add(subcategories);
  }

  @override
  Future<void> fetchSubcategories() async {
    final url =
        Uri.http(baseURL, '/api/subcategories', {'budgetId': await getBudgetId()});
    final response = await http.get(url, headers: await getHeaders());

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

    final resp = await http.delete(url, headers: await getHeaders());

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
}
