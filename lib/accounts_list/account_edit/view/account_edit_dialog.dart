import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qruto_budget/accounts_list/repository/account_repository.dart';
import 'package:qruto_budget/categories/repository/category_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/theme/budget_theme.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';
import '../account_edit.dart';

class AccountEditDialog extends StatelessWidget {
  const AccountEditDialog({super.key, this.accountId});

  final int? accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return AccountEditBloc(
            accountRepository: context.read<AccountRepository>(),
            categoryRepository: context.read<CategoryRepository>())
          ..add(AccountEditFormLoaded(accountId: accountId));
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
                  insetPadding: EdgeInsets.all(20.w),
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
                                  fontSize: 24.sp, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 20),
                            CategoryInputField(),
                            SizedBox(height: 25),
                            NameInputField(),
                            SizedBox(height: 25),
                            BalanceInputField(),
                            Divider(),
                            IncludeSwitch(),
                            Divider(),
                            SizedBox(height: 10),
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
      builder: (context, state) {
        final colors = context.read<ThemeCubit>().state;
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: colors.secondaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                ),
                onPressed: state.isValid && state.category != null
                    ? () {
                        context
                            .read<AccountEditBloc>()
                            .add(AccountFormSubmitted());
                        context.pop();
                      }
                    : null,
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: BudgetTheme.isDarkMode(context)
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 26.sp),
                ),
              );
      },
    );
  }
}
