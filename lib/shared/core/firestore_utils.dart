import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../constants/api.dart';
import '../../transactions/models/transaction_tile.dart';
import '../../transactions/models/transaction_type.dart';

extension FirestoreX on firestore.FirebaseFirestore {
  Future<void> saveTransaction(
      {required Transaction transaction,
      TransactionTile? editedTransaction,
      required Budget budget}) async {
    final batch = firestore.FirebaseFirestore.instance.batch();
    final transactionsRef = await budgetTransactions();
    final updatedBudget = _updateBudget(
        transaction: transaction,
        editedTransaction: editedTransaction,
        budget: budget);
    batch.set(
        transactionsRef
            .doc(editedTransaction != null ? editedTransaction.id : null),
        transaction.toFirestore());
    batch.set(await userBudget(), updatedBudget.toFirestore());
    batch.commit();
  }

  Future<firestore.DocumentReference<Map<String, dynamic>>> userBudget() async {
    final userId = await getUserId();
    final budgetId = await getCurrentBudgetId();
    return firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId);
  }

  Future<firestore.CollectionReference<Map<String, dynamic>>>
      budgetTransactions() async {
    final userId = await getUserId();
    final budgetId = await getCurrentBudgetId();
    return await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .collection('transactions');
  }

  Budget _updateBudget(
      {required Transaction transaction,
      TransactionTile? editedTransaction,
      required Budget budget}) {
    List<Account> updatedAccounts = [];

    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (editedTransaction != null) {
      updatedAccounts = budget.accountList.map((acc) {
        if (acc.id == editedTransaction.fromAccount!.id) {
          return acc.copyWith(
              balance: acc.balance +
                  (editedTransaction.type == TransactionType.EXPENSE
                      ? editedTransaction.amount
                      : -editedTransaction.amount));
        } else {
          return acc;
        }
      }).toList();
    } else {
      updatedAccounts = [...budget.accountList];
    }
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.accountId) {
        return acc.copyWith(
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? -transaction.amount!
                    : transaction.amount!));
      } else {
        return acc;
      }
    }).toList();

    return budget.copyWith(accountList: updatedAccounts);
  }
}
