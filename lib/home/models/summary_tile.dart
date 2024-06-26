import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../transaction/transaction.dart';

part 'summary_tile.g.dart';

@JsonSerializable(explicitToJson: true)
class SummaryTile extends Equatable {
  final String id;
  final String name;
  final double total;
  final List<ComprehensiveTransaction> comprehensiveTr;
  final int iconCodePoint;
  final bool isExpanded;

  const SummaryTile(
      {required this.id,
      required this.name,
      required this.total,
      this.comprehensiveTr = const [],
      required this.iconCodePoint,
      this.isExpanded = false});

  SummaryTile copyWith(
      {String? id,
      String? name,
      double? total,
      List<ComprehensiveTransaction>? comprehensiveTr,
      int? iconCodePoint,
      bool? isExpanded}) {
    return SummaryTile(
        id: id ?? this.id,
        name: name ?? this.name,
        total: total ?? this.total,
        comprehensiveTr: comprehensiveTr ?? this.comprehensiveTr,
        iconCodePoint: iconCodePoint ?? this.iconCodePoint,
        isExpanded: isExpanded ?? this.isExpanded);
  }

  factory SummaryTile.fromJson(Map<String, dynamic> json) =>
      _$SummaryTileFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryTileToJson(this);

  @override
  List<Object?> get props =>
      [id, total, comprehensiveTr, name, iconCodePoint, isExpanded];
}
