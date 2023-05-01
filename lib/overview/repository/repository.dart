import 'package:flutter/material.dart';

class DummyRepository {

  const DummyRepository();

  List<MainCategoryData> getMainCategoryList(){
    return <MainCategoryData>[
      MainCategoryData(name: 'EXPENSES', amount: '1782.09', iconCodePoint: Icons.wallet.codePoint),
      MainCategoryData(name: 'INCOME', amount: '3783.00', iconCodePoint: Icons.monetization_on_outlined.codePoint),
      MainCategoryData(name: 'ACCOUNTS', amount: '5493.67', iconCodePoint: Icons.account_balance.codePoint),
    ];
  }
}

class MainCategoryData {
  final String name;
  final String amount;
  final int iconCodePoint;

  const MainCategoryData({
    required this.name,
    required this.amount,
    required this.iconCodePoint,
  });
}
