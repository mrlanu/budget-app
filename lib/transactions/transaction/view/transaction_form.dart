import 'package:budget_app/colors.dart';
import 'package:budget_app/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:budget_app/transactions/transaction/view/widgets/account_input_field.dart';
import 'package:budget_app/transactions/transaction/view/widgets/amount_input_field.dart';
import 'package:budget_app/transactions/transaction/view/widgets/category_input_field.dart';
import 'package:budget_app/transactions/transaction/view/widgets/date_input_field.dart';
import 'package:budget_app/transactions/transaction/view/widgets/subcategory_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class TransactionForm extends StatelessWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 70.w, horizontal: 50.w),
            child: Column(
              children: [
                AmountInput(),
                SizedBox(
                  height: 75.h,
                ),
                DateInput(),
                SizedBox(
                  height: 75.h,
                ),
                CategoryInput(),
                SizedBox(
                  height: 75.h,
                ),
                SubcategoryInput(),
                SizedBox(
                  height: 75.h,
                ),
                AccountInput(),
                SizedBox(
                  height: 75.h,
                ),
                _NotesInput(),
                SizedBox(
                  height: 75.h,
                ),
                _SubmitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextFormField(
            initialValue: state.description,
            decoration: InputDecoration(
              icon: Icon(
                Icons.notes,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              border: OutlineInputBorder(),
              labelText: 'Notes',
            ),
            onChanged: (description) => context.read<TransactionBloc>().add(
                  TransactionNotesChanged(description: description),
                ));
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ListTile(
                tileColor: state.isValid &&
                    state.category != null &&
                    state.subcategory != null &&
                    state.account != null
                    ? BudgetColors.amber800
                    : BudgetColors.grey400,
                title: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: state.isValid &&
                                state.category != null &&
                                state.subcategory != null &&
                                state.account != null
                            ? Colors.black
                            : Colors.grey,
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize),
                  ),
                ),
                onTap: state.isValid &&
                        state.category != null &&
                        state.subcategory != null &&
                        state.account != null
                    ? () => context
                        .read<TransactionBloc>()
                        .add(TransactionFormSubmitted(context: context))
                    : null,
              );
      },
    );
  }
}
