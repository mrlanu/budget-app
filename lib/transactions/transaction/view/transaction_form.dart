import 'package:budget_app/accounts/models/account_brief.dart';
import 'package:budget_app/app/app.dart';
import 'package:budget_app/shared/models/category.dart';
import 'package:budget_app/shared/models/subcategory.dart';
import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/transactions/transaction/cubit/transaction_cubit.dart';
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
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        return TextField(
          onChanged: (amount) =>
              context.read<TransactionCubit>().amountChanged(amount),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            icon: Icon(
              Icons.attach_money,
              color: Colors.orangeAccent,
            ),
            border: OutlineInputBorder(),
            labelText: 'Amount',
            helperText: '',
            errorText: state.amount.isValid ? 'invalid amount' : null,
          ),
        );
      },
    );
  }
}

class _DateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
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
            onChanged: (value) {
              print('object');
            },
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101));
              if (pickedDate != null) {
                context.read<TransactionCubit>().dateChanged(pickedDate);
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
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        return DropdownButtonFormField(
            items: state.categories.map((Category category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransactionCubit>()
                  .categorySelected(newValue as Category);
              //setState(() => selectedValue = newValue);
            },
            value: state.selectedCategory,
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
    return BlocBuilder<TransactionCubit, TransactionState>(
      //buildWhen: (previous, current) => previous.selectedSubcategory != current.selectedSubcategory,
      builder: (context, state) {
        return DropdownButtonFormField(
            items: state.subcategories.map((Subcategory subcategory) {
              return DropdownMenuItem(
                value: subcategory,
                child: Text(subcategory.name),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransactionCubit>()
                  .subcategorySelected(newValue as Subcategory);
              //setState(() => selectedValue = newValue);
            },
            value: state.selectedSubcategory,
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
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        return DropdownButtonFormField(
            items: context
                .read<AppBloc>()
                .state
                .budget
                ?.accountBriefList
                .map((AccountBrief accountBrief) {
              return DropdownMenuItem(
                value: accountBrief,
                child: Text(accountBrief.name),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransactionCubit>()
                  .accountSelected(newValue as AccountBrief);
              //setState(() => selectedValue = newValue);
            },
            value: state.selectedAccount,
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
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (previous, current) => previous.notes != current.notes,
      builder: (context, state) {
        return TextField(
          onChanged: (notes) =>
              context.read<TransactionCubit>().notesChanged(notes),
          decoration: InputDecoration(
            icon: Icon(
              Icons.notes,
              color: Colors.orangeAccent,
            ),
            border: OutlineInputBorder(),
            labelText: 'Notes',
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
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
                        state.selectedCategory != null &&
                        state.selectedSubcategory != null &&
                        state.selectedAccount != null
                    ? () => context.read<TransactionCubit>().submit(context)
                    : null,
                child: const Text('ADD'),
              );
      },
    );
  }
}
