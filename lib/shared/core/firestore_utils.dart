import 'package:budget_app/budgets/budgets.dart';
import 'package:budget_app/transactions/models/transaction.dart';
import 'package:budget_app/transfer/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../constants/api.dart';
import '../../transactions/models/transaction_tile.dart';
import '../../transactions/models/transaction_type.dart';

extension FirestoreX on firestore.FirebaseFirestore {
  /*Future<void> saveTransaction(
      {required Transaction transaction,
      TransactionTile? editedTransaction,
      required Budget budget}) async {
    final batch = firestore.FirebaseFirestore.instance.batch();
    final transactionsRef = await getRefToAllBudgetTransactions();
    final updatedBudget = _updateBudgetOnAddOrEditTransaction(
        transaction: transaction,
        editedTransaction: editedTransaction,
        budget: budget);
    batch.set(
        transactionsRef
            .doc(editedTransaction != null ? editedTransaction.id : null),
        transaction.toFirestore());
    //batch.set(await getRefToCurrentBudget(), updatedBudget.toFirestore());
    batch.commit();
  }

  Future<void> saveTransfer(
      {required Transfer transfer,
      TransactionTile? editedTransfer,
      required Budget budget}) async {
    final batch = firestore.FirebaseFirestore.instance.batch();
    final transactionsRef = await getRefToAllBudgetTransactions();
    final updatedBudget = _updateBudgetOnTransfer(
        transfer: transfer, editedTransfer: editedTransfer, budget: budget);
    batch.set(
        transactionsRef.doc(editedTransfer != null ? editedTransfer.id : null),
        transfer.toFirestore());
    //batch.set(await getRefToCurrentBudget(), updatedBudget.toFirestore());
    batch.commit();
  }*/

  Future<void> deleteTransaction(
      {required TransactionTile transaction, required Budget budget}) async {
    final batch = firestore.FirebaseFirestore.instance.batch();
    final transactionsRef = await getRefToAllBudgetTransactions();
    final updatedBudget = transaction.type != TransactionType.TRANSFER
        ? _updateBudgetOnDeleteTransaction(
        transaction: transaction, budget: budget)
        : _updateBudgetOnDeleteTransfer(
        transaction: transaction, budget: budget);
    batch.delete(transactionsRef.doc(transaction.id));
    //batch.set(await getRefToCurrentBudget(), updatedBudget.toFirestore());
    batch.commit();
  }

  Future<firestore.DocumentReference<Map<String, dynamic>>> getRefToCurrentBudget() async {
    final userId = await getUserId();
    final budgetId = await getCurrentBudgetId();
    return firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId);
  }

  Future<firestore.CollectionReference<Map<String, dynamic>>>
      getRefToAllBudgetTransactions() async {
    final userId = await getUserId();
    final budgetId = await getCurrentBudgetId();
    return await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .collection('transactions');
  }

  Future<firestore.Query<Map<String, dynamic>>> queryTransactionsByDate(
      DateTime dateTime) async {
    final userId = await getUserId();
    final budgetId = await getCurrentBudgetId();
    return await firestore.FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('budgets')
        .doc(budgetId)
        .collection('transactions')
        .where('date',
            isGreaterThanOrEqualTo: firestore.Timestamp.fromDate(
                DateTime(dateTime.year, dateTime.month)),
            isLessThan: firestore.Timestamp.fromDate(
                DateTime(dateTime.year, dateTime.month + 1)));
  }

  Budget _updateBudgetOnAddOrEditTransaction(
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

  Budget _updateBudgetOnDeleteTransfer(
      {required TransactionTile transaction, required Budget budget}) {
    List<Account> updatedAccounts = [];

    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    updatedAccounts = budget.accountList.map((acc) {
      if (acc.id == transaction.fromAccount!.id) {
        return acc.copyWith(balance: acc.balance + transaction.amount);
      } else {
        return acc;
      }
    }).toList();
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.toAccount!.id) {
        return acc.copyWith(balance: acc.balance - transaction.amount);
      } else {
        return acc;
      }
    }).toList();

    return budget.copyWith(accountList: updatedAccounts);
  }

  Budget _updateBudgetOnDeleteTransaction(
      {required TransactionTile transaction, required Budget budget}) {
    List<Account> updatedAccounts = [...budget.accountList];
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transaction.fromAccount!.id) {
        return acc.copyWith(
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? transaction.amount
                    : -transaction.amount));
      } else {
        return acc;
      }
    }).toList();

    return budget.copyWith(accountList: updatedAccounts);
  }

  Budget _updateBudgetOnTransfer(
      {required Transfer transfer,
      TransactionTile? editedTransfer,
      required Budget budget}) {
    List<Account> updatedAccounts = [];

    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (editedTransfer != null) {
      updatedAccounts = budget.accountList.map((acc) {
        if (acc.id == editedTransfer.fromAccount!.id) {
          return acc.copyWith(balance: acc.balance + editedTransfer.amount);
        } else {
          return acc;
        }
      }).toList();
      updatedAccounts = updatedAccounts.map((acc) {
        if (acc.id == editedTransfer.toAccount!.id) {
          return acc.copyWith(balance: acc.balance - editedTransfer.amount);
        } else {
          return acc;
        }
      }).toList();
    } else {
      updatedAccounts = [...budget.accountList];
    }

    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transfer.fromAccountId) {
        return acc.copyWith(balance: acc.balance - transfer.amount);
      } else {
        return acc;
      }
    }).toList();
    updatedAccounts = updatedAccounts.map((acc) {
      if (acc.id == transfer.toAccountId) {
        return acc.copyWith(balance: acc.balance + transfer.amount);
      } else {
        return acc;
      }
    }).toList();

    return budget.copyWith(accountList: updatedAccounts);
  }
}
