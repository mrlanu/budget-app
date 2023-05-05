import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared.dart';
import '../models/section_summary.dart';

part 'sections_state.dart';

class SectionsCubit extends Cubit<SectionsState> {
  final User user;

  SectionsCubit(this.user) : super(SectionsState());

  Future<void> fetchAllSections() async {
    try {
      final sections = await _fetchSections();
      emit(state.copyWith(
          status: DataStatus.success, sectionSummaryList: sections));
    } catch (e) {
      emit(
          state.copyWith(status: DataStatus.error, errorMessage: e.toString()));
    }
  }

  Future<List<SectionSummary>> _fetchSections() async {
    final url = 'http://10.0.2.2:8080/api/budgets/sections';

    final token = await user.token;
    final response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    print('SECTIONS: ${response.body}');

    final sections = List<Map<dynamic, dynamic>>.from(
      json.decode(response.body) as List,
    )
        .map((jsonMap) =>
            SectionSummary.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();

    return sections;
  }
}
