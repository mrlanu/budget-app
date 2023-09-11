import 'package:budget_app/constants/api.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../budgets/budgets.dart';

abstract class BudgetRepository {
  Stream<Budget> get budgets;
  Future<List<Budget>> fetchAvailableBudgets(String userId);
  Future<void> createBeginningBudget({required String userId});
}

class BudgetRepositoryImpl extends BudgetRepository {
  final FirebaseFirestore _firebaseFirestore;

  BudgetRepositoryImpl(
      {FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance {
  }

  Stream<Budget> get budgets async* {
    final userId = await getUserId();
    final budgetId = await getCurrentBudgetId();
    yield* _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .snapshots()
        .map((event) => Budget.fromFirestore(event));
  }
  
  Future<List<Budget>> fetchAvailableBudgets(String userId) async {
    final budgets = (await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .get()).docs.map((e) => Budget.fromFirestore(e)).toList();
    return budgets;
  }

  Future<void> createBeginningBudget({required String userId}) async {
    final ref = await _firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .add(Budget().toFirestore());

    final beginningBudget = Budget(
        id: ref.id, categoryList: categoryList, accountList: accountList);

    await _firebaseFirestore
        .doc('users/$userId/budgets/${ref.id}')
        .set(beginningBudget.toFirestore());
  }
}

final categoryList = <Category>[
  Category(
      name: 'Fun',
      iconCode: 62922,
      subcategoryList: [
        Subcategory(name: 'Alcohol'),
        Subcategory(name: 'Girls')
      ],
      type: TransactionType.EXPENSE),
  Category(
      name: 'Bills',
      iconCode: 61675,
      subcategoryList: [
        Subcategory(name: 'Gas'),
        Subcategory(name: 'Electricity')
      ],
      type: TransactionType.EXPENSE),
  Category(
      name: 'Checking',
      iconCode: 61675,
      subcategoryList: [],
      type: TransactionType.ACCOUNT),
];
final accountList = <Account>[
  Account(
      id: Uuid().v4(),
      name: 'Chase',
      categoryName: 'Checking',
      balance: 2000.0,
      initialBalance: 2000.0)
];
