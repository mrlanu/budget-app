// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBudgetCollection on Isar {
  IsarCollection<Budget> get budgets => this.collection();
}

const BudgetSchema = CollectionSchema(
  name: r'Budget',
  id: -3383598594604670326,
  properties: {
    r'accountList': PropertySchema(
      id: 0,
      name: r'accountList',
      type: IsarType.objectList,
      target: r'Account',
    ),
    r'categoryList': PropertySchema(
      id: 1,
      name: r'categoryList',
      type: IsarType.objectList,
      target: r'Category',
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    )
  },
  estimateSize: _budgetEstimateSize,
  serialize: _budgetSerialize,
  deserialize: _budgetDeserialize,
  deserializeProp: _budgetDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'Category': CategorySchema,
    r'Subcategory': SubcategorySchema,
    r'Account': AccountSchema
  },
  getId: _budgetGetId,
  getLinks: _budgetGetLinks,
  attach: _budgetAttach,
  version: '3.1.0+1',
);

int _budgetEstimateSize(
  Budget object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountList.length * 3;
  {
    final offsets = allOffsets[Account]!;
    for (var i = 0; i < object.accountList.length; i++) {
      final value = object.accountList[i];
      bytesCount += AccountSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.categoryList.length * 3;
  {
    final offsets = allOffsets[Category]!;
    for (var i = 0; i < object.categoryList.length; i++) {
      final value = object.categoryList[i];
      bytesCount += CategorySchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _budgetSerialize(
  Budget object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<Account>(
    offsets[0],
    allOffsets,
    AccountSchema.serialize,
    object.accountList,
  );
  writer.writeObjectList<Category>(
    offsets[1],
    allOffsets,
    CategorySchema.serialize,
    object.categoryList,
  );
  writer.writeString(offsets[2], object.id);
}

Budget _budgetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Budget(
    accountList: reader.readObjectList<Account>(
          offsets[0],
          AccountSchema.deserialize,
          allOffsets,
          Account(),
        ) ??
        const [],
    categoryList: reader.readObjectList<Category>(
          offsets[1],
          CategorySchema.deserialize,
          allOffsets,
          Category(),
        ) ??
        const [],
    id: reader.readStringOrNull(offsets[2]) ?? '',
    isarId: id,
  );
  return object;
}

P _budgetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<Account>(
            offset,
            AccountSchema.deserialize,
            allOffsets,
            Account(),
          ) ??
          const []) as P;
    case 1:
      return (reader.readObjectList<Category>(
            offset,
            CategorySchema.deserialize,
            allOffsets,
            Category(),
          ) ??
          const []) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _budgetGetId(Budget object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _budgetGetLinks(Budget object) {
  return [];
}

void _budgetAttach(IsarCollection<dynamic> col, Id id, Budget object) {}

extension BudgetQueryWhereSort on QueryBuilder<Budget, Budget, QWhere> {
  QueryBuilder<Budget, Budget, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BudgetQueryWhere on QueryBuilder<Budget, Budget, QWhereClause> {
  QueryBuilder<Budget, Budget, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Budget, Budget, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetQueryFilter on QueryBuilder<Budget, Budget, QFilterCondition> {
  QueryBuilder<Budget, Budget, QAfterFilterCondition> accountListLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'accountList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> accountListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'accountList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> accountListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'accountList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> accountListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'accountList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition>
      accountListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'accountList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> accountListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'accountList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> categoryListLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> categoryListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> categoryListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition>
      categoryListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition>
      categoryListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> categoryListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoryList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> isarIdGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> isarIdLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> isarIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetQueryObject on QueryBuilder<Budget, Budget, QFilterCondition> {
  QueryBuilder<Budget, Budget, QAfterFilterCondition> accountListElement(
      FilterQuery<Account> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'accountList');
    });
  }

  QueryBuilder<Budget, Budget, QAfterFilterCondition> categoryListElement(
      FilterQuery<Category> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'categoryList');
    });
  }
}

extension BudgetQueryLinks on QueryBuilder<Budget, Budget, QFilterCondition> {}

extension BudgetQuerySortBy on QueryBuilder<Budget, Budget, QSortBy> {
  QueryBuilder<Budget, Budget, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension BudgetQuerySortThenBy on QueryBuilder<Budget, Budget, QSortThenBy> {
  QueryBuilder<Budget, Budget, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Budget, Budget, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }
}

extension BudgetQueryWhereDistinct on QueryBuilder<Budget, Budget, QDistinct> {
  QueryBuilder<Budget, Budget, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }
}

extension BudgetQueryProperty on QueryBuilder<Budget, Budget, QQueryProperty> {
  QueryBuilder<Budget, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Budget, List<Account>, QQueryOperations> accountListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountList');
    });
  }

  QueryBuilder<Budget, List<Category>, QQueryOperations>
      categoryListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryList');
    });
  }

  QueryBuilder<Budget, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Budget _$BudgetFromJson(Map<String, dynamic> json) => Budget(
      id: json['id'] as String? ?? '',
      categoryList: (json['categoryList'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      accountList: (json['accountList'] as List<dynamic>?)
              ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BudgetToJson(Budget instance) => <String, dynamic>{
      'id': instance.id,
      'categoryList': instance.categoryList.map((e) => e.toJson()).toList(),
      'accountList': instance.accountList.map((e) => e.toJson()).toList(),
    };
