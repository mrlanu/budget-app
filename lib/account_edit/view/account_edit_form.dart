import 'package:budget_app/account_edit/bloc/account_edit_bloc.dart';
import 'package:budget_app/account_edit/view/widgets/balance_input_field.dart';
import 'package:budget_app/account_edit/view/widgets/category_input_field.dart';
import 'package:budget_app/account_edit/view/widgets/include_switch.dart';
import 'package:budget_app/account_edit/view/widgets/name_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class AccountEditDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountEditBloc, AccountEditState>(
      builder: (context, state) {
        return state.accStatus == AccountEditStatus.loading
            ? Center(child: CircularProgressIndicator())
            : Dialog(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                insetPadding: EdgeInsets.all(10),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 1500.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.secondaryContainer,
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
                            height: 50.h,
                          ),
                          CategoryInputField(),
                          SizedBox(
                            height: 75.h,
                          ),
                          NameInputField(),
                          SizedBox(
                            height: 75.h,
                          ),
                          BalanceInputField(),
                          SizedBox(
                            height: 75.h,
                          ),
                          IncludeSwitch(),
                          SizedBox(
                            height: 75.h,
                          ),
                          _SubmitButton(),
                        ],
                      ),
                    ),
                    /*Positioned(
                    top: -100,
                    child: Image.network("https://i.imgur.com/2yaf2wb.png",
                        width: 150, height: 150))*/
                  ],
                ));
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
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                onPressed: state.isValid && state.category != null
                    ? () => context
                        .read<AccountEditBloc>()
                        .add(AccountFormSubmitted(context: context))
                    : null,
                child: Text('SAVE'),
              );
      },
    );
  }
}
