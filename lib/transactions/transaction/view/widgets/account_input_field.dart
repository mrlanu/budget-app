import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../accounts/models/account_brief.dart';
import '../../bloc/transaction_bloc.dart';

class AccountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return DropdownButtonFormField<AccountBrief>(
            icon: GestureDetector(
              child: Icon(Icons.add),
              onTap: (){

              },
            ),
            items: state.accounts.map((AccountBrief accountBrief) {
              return DropdownMenuItem(
                value: accountBrief,
                child: Text(accountBrief.name),
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
