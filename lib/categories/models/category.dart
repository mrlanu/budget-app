import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../../subcategories/models/subcategory.dart';
import '../../transaction/transaction.dart';

part 'category.g.dart';

@Collection(inheritance: false)
class Category extends Equatable {
  final Id? id;
  final String name;
  final int iconCode;
  final List<Subcategory> subcategoryList;
  @enumerated
  final TransactionType type;

  Category(
      {this.id,
      this.name = '',
      this.iconCode = 0,
      this.subcategoryList = const [],
      this.type = TransactionType.EXPENSE});

  Category copyWith(
      {String? name,
      int? iconCode,
      List<Subcategory>? subcategoryList,
      TransactionType? type}) {
    return Category(
      id: this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      subcategoryList: subcategoryList ?? this.subcategoryList,
      iconCode: iconCode ?? this.iconCode,
    );
  }

  @override
  @ignore
  List<Object?> get props => [id, name, subcategoryList];
}
