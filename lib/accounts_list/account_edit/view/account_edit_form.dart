import 'package:budget_app/accounts_list/account_edit/view/widgets/balance_input_field.dart';
import 'package:budget_app/accounts_list/account_edit/view/widgets/category_input_field.dart';
import 'package:budget_app/accounts_list/account_edit/view/widgets/include_switch.dart';
import 'package:budget_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/account_edit_bloc.dart';
import 'widgets/name_input_field.dart';

class AccountEditDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountEditBloc, AccountEditState>(
      builder: (context, state) {
        return state.accStatus == AccountEditStatus.loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  child: Dialog(
                      insetPadding: EdgeInsets.all(10),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            height: 495,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: BudgetColors.teal50,
                            ),
                            padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                            child: Column(
                              children: [
                                Text(
                                  'New Account',
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.fontSize),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CategoryInputField(),
                                SizedBox(
                                  height: 25,
                                ),
                                NameInputField(),
                                SizedBox(
                                  height: 25,
                                ),
                                BalanceInputField(),
                                Divider(),
                                IncludeSwitch(),
                                Divider(),
                                _SubmitButton(),
                              ],
                            ),
                          ),
                          /*Positioned(
                        top: -100,
                        child: Image.network("https://i.imgur.com/2yaf2wb.png",
                            width: 150, height: 150))*/
                        ],
                      )),
                ),
              );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountEditBloc, AccountEditState>(
      //buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : TextButton(
                onPressed: state.isValid && state.category != null
                    ? () => context
                        .read<AccountEditBloc>()
                        .add(AccountFormSubmitted(context: context))
                    : null,
                child: Text('SAVE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: state.isValid && state.category != null
                            ? BudgetColors.amber800
                            : Colors.grey)),
              );
      },
    );
  }
}
