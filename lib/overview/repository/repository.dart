import 'package:budget_app/accounts/view/accounts_page.dart';
import 'package:flutter/material.dart';

class DummyRepository {

  const DummyRepository();

  List<MainCategoryData> getMainCategoryList(){
    return <MainCategoryData>[
      MainCategoryData(name: 'EXPENSES', routeName: '/expenses', amount: '1782.09', iconCodePoint: Icons.wallet.codePoint),
      MainCategoryData(name: 'INCOME', routeName: '/income', amount: '3783.00', iconCodePoint: Icons.monetization_on_outlined.codePoint),
      MainCategoryData(name: 'ACCOUNTS', routeName: AccountsPage.routeName, amount: '5493.67', iconCodePoint: Icons.account_balance.codePoint),
    ];
  }
}

class MainCategoryData {
  final String name;
  final String routeName;
  final String amount;
  final int iconCodePoint;

  const MainCategoryData({
    required this.name,
    required this.routeName,
    required this.amount,
    required this.iconCodePoint,
  });
}
