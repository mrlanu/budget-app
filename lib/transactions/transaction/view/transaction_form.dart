import 'package:budget_app/colors.dart';
import 'package:budget_app/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:budget_app/transactions/transaction/view/widgets/account_input_field.dart';
import 'package:budget_app/transactions/transaction/view/widgets/amount_input_field.dart';
import 'package:budget_app/transactions/transaction/view/widgets/category_input_field.dart';
import 'package:budget_app/transactions/transaction/view/widgets/date_input_field.dart';
import 'package:budget_app/transactions/transaction/view/widgets/subcategory_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../constants/constants.dart';

class TransactionForm extends StatelessWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: h * 0.04, horizontal: 30),
            child: Column(
              children: [
                AmountInput(),
                SizedBox(
                  height: 20,
                ),
                DateInput(),
                SizedBox(
                  height: 20,
                ),
                CategoryInput(),
                SizedBox(
                  height: 20,
                ),
                SubcategoryInput(),
                SizedBox(
                  height: 20,
                ),
                AccountInput(),
                SizedBox(
                  height: 20,
                ),
                _NotesInput(),
                SizedBox(
                  height: 20,
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
