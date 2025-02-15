import 'package:budget_app/accounts_list/repository/account_repository.dart';
import 'package:budget_app/categories/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/theme/cubit/theme_cubit.dart';
import '../account_edit.dart';

class AccountEditDialog extends StatelessWidget {
  const AccountEditDialog({super.key, this.accountId});

  final int? accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = AccountEditBloc(
            accountRepository: context.read<AccountRepository>(),
            categoryRepository: context.read<CategoryRepository>());
        bloc.stream
            .where((state) => state.accounts.isNotEmpty)
            .first
            .then((_) {
          bloc.add(AccountEditFormLoaded(accountId: accountId));
        });
        return bloc;
      },
      child: AccountEditForm(),
    );
  }
}

class AccountEditForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accStatus =
        context.select((AccountEditBloc bloc) => bloc.state.accStatus);
    return accStatus == AccountEditStatus.loading
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
                    ],
                  )),
            ),
          );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountEditBloc, AccountEditState>(
      //buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        final themeState = context.read<ThemeCubit>().state;
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : TextButton(
                onPressed: state.isValid && state.category != null
                    ? () {
                        context
                            .read<AccountEditBloc>()
                            .add(AccountFormSubmitted());
                        context.pop();
                      }
                    : null,
                child: Text('SAVE',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: state.isValid && state.category != null
                            ? themeState.secondaryColor
                            : Colors.grey)),
              );
      },
    );
  }
}
