enum FilterBy {
  categoryId,
  accountId,
  allExpenses,
  allIncomes,
}

class TransactionsFilter {
  final FilterBy filterBy;
  final String? id;

  const TransactionsFilter({required this.filterBy, this.id});
}