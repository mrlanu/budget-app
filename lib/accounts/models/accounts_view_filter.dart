import 'account.dart';

class AccountsViewFilter {
  final String filterId;
  const AccountsViewFilter({required this.filterId});

  bool apply({required Account account}) {
    return account.categoryId == filterId;
    }

  List<Account> applyAll(Iterable<Account> accountsList) {
    return accountsList.where((acc) => apply(account: acc)).toList();
  }
}
