import '../../accounts_list/models/account.dart';
import '../../transaction/models/transaction.dart';
import '../../transaction/models/transaction_type.dart';
import '../models/models.dart';

class SharedExtension {

  static Future<List<Account>> updateBudgetOnTransaction(
      {required Budget budget,
        required Transaction transaction,
        Transaction? editedTransaction}) async {
    List<Account> updatedAccounts = [];

    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (transaction.id != null) {
      updatedAccounts = budget.accountList.map((acc) {
        if (acc.id == editedTransaction!.fromAccountId) {
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
      if (acc.id == transaction.fromAccountId) {
        return acc.copyWith(
            balance: acc.balance +
                (transaction.type == TransactionType.EXPENSE
                    ? -transaction.amount
                    : transaction.amount));
      } else {
        return acc;
      }
    }).toList();

    return updatedAccounts;
  }

  static Future<List<Account>> updateBudgetOnTransfer(
      {required Budget budget,
        required Transaction transfer,
        Transaction? editedTransaction}) async {
    List<Account> updatedAccounts = [];

    //find the acc from editedTransaction and return amount
    //find the acc from transaction and update amount
    if (transfer.id != null) {
      updatedAccounts = budget.accountList.map((acc) {
        if (acc.id == editedTransaction!.fromAccountId) {
          return acc.copyWith(balance: acc.balance + editedTransaction.amount);
        } else {
          return acc;
        }
      }).toList();
      updatedAccounts = updatedAccounts.map((acc) {
        if (acc.id == editedTransaction!.toAccountId) {
          return acc.copyWith(balance: acc.balance - editedTransaction.amount);
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

    return updatedAccounts;
  }
}
