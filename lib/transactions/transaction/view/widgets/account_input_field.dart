import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../accounts/models/account.dart';
import '../../../../categories/models/category.dart';
import '../../bloc/transaction_bloc.dart';

class AccountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return DropdownButtonFormField<Account>(
            icon: GestureDetector(
              child: Icon(Icons.edit_note),
              onTap: (){

              },
            ),
            items: state.accounts.map((Account account) {
              return DropdownMenuItem(
                value: account,
                child: Text(account.extendName(state.accountCategories)),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransactionBloc>()
                  .add(TransactionAccountChanged(account: newValue));
              //setState(() => selectedValue = newValue);
            },
            value: state.account,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_balance,
                color: Colors.orangeAccent,
              ),
              border: OutlineInputBorder(),
              labelText: 'Account',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}

extension on Account {
  String extendName(List<Category> categories){
    final category = categories.where((element) => element.id == this.categoryId).first;
    return '${category.name} / ${this.name}';
  }
}
