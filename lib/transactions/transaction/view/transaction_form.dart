import 'package:budget_app/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:budget_app/transactions/transaction/view/widgets/account_input_field.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 50.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _AmountInput(),
            SizedBox(
              height: 30.h,
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
            _SubmitButton()
          ],
        ),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.amount.value,
          onChanged: (amount) => context
              .read<TransactionBloc>()
              .add(TransactionAmountChanged(amount: amount)),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(
              Icons.attach_money,
              color: Colors.orangeAccent,
            ),
            border: OutlineInputBorder(),
            labelText: 'Amount',
            helperText: '',
            errorText:
                state.amount.displayError != null ? 'invalid amount' : null,
          ),
        );
      },
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
                color: Colors.orangeAccent,
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
                onPressed: state.isValid &&
                        state.category != null &&
                        state.subcategory != null &&
                        state.account != null
                    ? () => context
                        .read<TransactionBloc>()
                        .add(TransactionFormSubmitted(context: context))
                    : null,
                child: Text(state.isEdit ? 'SAVE' : 'ADD'),
              );
      },
    );
  }
}
