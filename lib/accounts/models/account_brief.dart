import 'package:json_annotation/json_annotation.dart';

part 'account_brief.g.dart';

@JsonSerializable()
class AccountBrief {
  final String id;
  final String name;
  final String categoryId;

  const AccountBrief({required this.id, required this.name, required this.categoryId});

  factory AccountBrief.fromJson(Map<String, dynamic> json) => _$AccountBriefFromJson(json);
  Map<String, dynamic> toJson() => _$AccountBriefToJson(this);
}
