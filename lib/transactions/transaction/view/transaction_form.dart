import 'package:budget_app/accounts/models/account_brief.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/shared/models/category.dart';
import 'package:budget_app/shared/models/subcategory.dart';
import 'package:budget_app/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

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
            _DateInput(),
            SizedBox(
              height: 75.h,
            ),
            _CategoryInput(),
            SizedBox(
              height: 75.h,
            ),
            _SubcategoryInput(),
            SizedBox(
              height: 75.h,
            ),
            _AccountInput(),
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

class _DateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      buildWhen: (previous, current) => previous.date != current.date,
      builder: (context, state) {
        return TextFormField(
            controller: TextEditingController(
                text: state.date != null
                    ? DateFormat('MM-dd-yyyy').format(state.date!)
                    : DateFormat('MM-dd-yyyy').format(DateTime.now())),
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.orangeAccent,
                ),
                labelText: "Date"),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));
              if (pickedDate != null) {
                context
                    .read<TransactionBloc>()
                    .add(TransactionDateChanged(dateTime: pickedDate));
              } else {
                print("Date is not selected");
              }
            });
      },
    );
  }
}

class _CategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return DropdownButtonFormField<Category>(
            items: state.categories.map((Category category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransactionBloc>()
                  .add(TransactionCategoryChanged(category: newValue));
              //setState(() => selectedValue = newValue);
            },
            value: state.category,
            decoration: InputDecoration(
              icon: Icon(
                Icons.category,
                color: Colors.orangeAccent,
              ),
              border: OutlineInputBorder(),
              labelText: 'Category',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}

class _SubcategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      //buildWhen: (previous, current) => previous.selectedSubcategory != current.selectedSubcategory,
      builder: (context, state) {
        return DropdownButtonFormField<Subcategory>(
            items: state.subcategories.map((Subcategory subcategory) {
              return DropdownMenuItem(
                value: subcategory,
                child: Text(subcategory.name),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransactionBloc>()
                  .add(TransactionSubcategoryChanged(subcategory: newValue));
              //setState(() => selectedValue = newValue);
            },
            value: state.subcategory,
            decoration: InputDecoration(
              icon: Icon(
                Icons.category_outlined,
                color: Colors.orangeAccent,
              ),
              border: OutlineInputBorder(),
              labelText: 'Subcategory',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }
}

class _AccountInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return DropdownButtonFormField<AccountBrief>(
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

class _NotesInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      buildWhen: (previous, current) => previous.notes != current.notes,
      builder: (context, state) {
        return TextField(
            decoration: InputDecoration(
              icon: Icon(
                Icons.notes,
                color: Colors.orangeAccent,
              ),
              border: OutlineInputBorder(),
              labelText: 'Notes',
            ),
            onChanged: (notes) => context.read<TransactionBloc>().add(
                  TransactionNotesChanged(notes: notes),
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
                child: const Text('ADD'),
              );
      },
    );
  }
}
