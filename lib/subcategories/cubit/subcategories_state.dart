part of 'subcategories_cubit.dart';

enum SubcategoriesStatus { loading, success, failure }

class SubcategoriesState extends Equatable {
  final SubcategoriesStatus status;
  final Budget? budget;
  final List<Subcategory> subcategories;
  final Category? category;
  final String? name;
  final String? errorMessage;

  const SubcategoriesState({
    this.status = SubcategoriesStatus.loading,
    this.budget,
    this.subcategories = const [],
    this.category,
    this.name,
    this.errorMessage,
  });

  SubcategoriesState copyWith({
    SubcategoriesStatus? status,
    Budget? budget,
    List<Subcategory>? subcategories,
    Category? category,
    String? name,
    Subcategory? editSubcategory,
    String? errorMessage,
  }) {
    return SubcategoriesState(
        status: status ?? this.status,
        budget: budget ?? this.budget,
        subcategories: subcategories ?? this.subcategories,
        category: category ?? this.category,
        name: name ?? this.name,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  SubcategoriesState resetSubcategory() {
    return SubcategoriesState(
        status: this.status,
        subcategories: this.subcategories,
        category: this.category,
        name: this.name);
  }

  @override
  List<Object?> get props =>
      [status, budget, subcategories, category, name, errorMessage];
}
