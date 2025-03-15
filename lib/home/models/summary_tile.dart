import 'package:equatable/equatable.dart';

import '../../transaction/transaction.dart';

class SummaryTile extends Equatable {
  final String name;
  final double total;
  final List<TransactionTile> transactionTiles;
  final int iconCodePoint;
  final bool isExpanded;

  const SummaryTile(
      {required this.name,
      required this.total,
      this.transactionTiles = const [],
      required this.iconCodePoint,
      this.isExpanded = false});

  SummaryTile copyWith(
      {String? name,
      double? total,
      List<TransactionTile>? transactionTiles,
      int? iconCodePoint,
      bool? isExpanded}) {
    return SummaryTile(
        name: name ?? this.name,
        total: total ?? this.total,
        transactionTiles: transactionTiles ?? this.transactionTiles,
        iconCodePoint: iconCodePoint ?? this.iconCodePoint,
        isExpanded: isExpanded ?? this.isExpanded);
  }

  @override
  List<Object?> get props =>
      [total, transactionTiles, name, iconCodePoint, isExpanded];
}
