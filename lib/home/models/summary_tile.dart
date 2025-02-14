import 'package:equatable/equatable.dart';

import '../../transaction/transaction.dart';

class SummaryTile extends Equatable {
  final int id;
  final String name;
  final double total;
  final List<TransactionTile> comprehensiveTr;
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
      {int? id,
      String? name,
      double? total,
      List<TransactionTile>? comprehensiveTr,
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

  @override
  List<Object?> get props =>
      [id, total, comprehensiveTr, name, iconCodePoint, isExpanded];
}
