import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_app/categories/models/category_summary.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {

  final User user;

  CategoriesCubit(this.user) : super(CategoriesState());

  Future<void> fetchAllCategories(String section) async {
    try {
      final categories = await _fetchCategories(section);
      emit(state.copyWith(
          status: DataStatus.success, categorySummaryList: categories));
    } catch (e) {
      emit(
          state.copyWith(status: DataStatus.error, errorMessage: e.toString()));
    }
  }

  Future<List<CategorySummary>> _fetchCategories(String section) async {
    final url = 'http://10.0.2.2:8080/api/budgets/categories?section=$section';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    print('CATEGORIES: ${response.body}');

    final result = List<Map<dynamic, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
        CategorySummary.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    return result;
  }
}
