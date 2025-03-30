import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../transaction/models/transaction_type.dart';

class PredefinedCategory {
  final String name;
  final IconData icon;
  final TransactionType type;
  final List<String> subcategories;

  PredefinedCategory(this.name, this.icon, this.type,
      [this.subcategories = const []]);
}

final predefinedCategories = <PredefinedCategory>[
  PredefinedCategory('Checking', FontAwesomeIcons.buildingColumns,
      TransactionType.ACCOUNT, []),
  PredefinedCategory(
      'Housing', FontAwesomeIcons.house, TransactionType.EXPENSE, [
    'Rent',
    'Mortgage',
    'Repairs',
    'Property Tax',
  ]),
  PredefinedCategory(
      'Utilities', FontAwesomeIcons.bolt, TransactionType.EXPENSE, [
    'Electricity',
    'Water',
    'Gas',
    'Internet',
    'Trash',
  ]),
  PredefinedCategory(
      'Food', FontAwesomeIcons.utensils, TransactionType.EXPENSE, [
    'Groceries',
    'Dining Out',
    'Coffee',
  ]),
  PredefinedCategory(
      'Transportation', FontAwesomeIcons.car, TransactionType.EXPENSE, [
    'Gas',
    'Car Payment',
    'Maintenance',
    'Public Transit',
    'Insurance',
  ]),
  PredefinedCategory('Health & Insurance', FontAwesomeIcons.briefcaseMedical,
      TransactionType.EXPENSE, [
    'Medical Bills',
    'Medication',
    'Health Insurance',
    'Dental',
    'Vision',
  ]),
  PredefinedCategory(
      'Personal', FontAwesomeIcons.user, TransactionType.EXPENSE, [
    'Clothing',
    'Haircuts',
    'Subscriptions',
    'Gym',
  ]),
  PredefinedCategory('Debt Payments', FontAwesomeIcons.moneyBillTransfer,
      TransactionType.EXPENSE, [
    'Credit Cards',
    'Student Loans',
    'Personal Loans',
  ]),
  PredefinedCategory('Savings & Investments', FontAwesomeIcons.piggyBank,
      TransactionType.EXPENSE, [
    'Emergency Fund',
    'Retirement',
    'Investments',
    'Donations',
  ]),
  PredefinedCategory(
      'Entertainment', FontAwesomeIcons.film, TransactionType.EXPENSE, [
    'Movies',
    'Concerts',
    'Games',
    'Events',
  ]),
  PredefinedCategory(
      'Kids & Education', FontAwesomeIcons.school, TransactionType.EXPENSE, [
    'Childcare',
    'School Supplies',
    'Tuition',
    'Extracurriculars',
  ]),
  PredefinedCategory('Pets', FontAwesomeIcons.paw, TransactionType.EXPENSE, [
    'Food',
    'Vet',
    'Grooming',
  ]),
  PredefinedCategory(
      'Gifts & Holidays', FontAwesomeIcons.gift, TransactionType.EXPENSE, [
    'Birthdays',
    'Christmas',
    'Anniversaries',
  ]),
  PredefinedCategory(
      'Travel', FontAwesomeIcons.plane, TransactionType.EXPENSE, [
    'Flights',
    'Hotels',
    'Rental Cars',
    'Travel Insurance',
  ]),
  PredefinedCategory(
      'Miscellaneous', FontAwesomeIcons.ellipsis, TransactionType.EXPENSE, [
    'Unexpected',
    'Fees',
    'Fines',
  ]),
  // Income
  PredefinedCategory('Salary', FontAwesomeIcons.wallet, TransactionType.INCOME),
  PredefinedCategory(
      'Freelance', FontAwesomeIcons.laptopCode, TransactionType.INCOME),
  PredefinedCategory(
      'Investments', FontAwesomeIcons.chartLine, TransactionType.INCOME),
  PredefinedCategory('Other Income', FontAwesomeIcons.moneyCheckDollar,
      TransactionType.INCOME),
];
