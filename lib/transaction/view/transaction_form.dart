import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../constants/constants.dart';
import '../../constants/colors.dart';
import '../../utils/theme/cubit/theme_cubit.dart';
import '../transaction.dart';

class TransactionForm extends StatelessWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
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
    final themeState = context.watch<ThemeCubit>().state;
    final description = context.select((TransactionBloc bloc) => bloc.state.description);
    return TextFormField(
            initialValue: description,
            decoration: InputDecoration(
              icon: Icon(
                Icons.notes,
                color: themeState.secondaryColor,
              ),
              border: OutlineInputBorder(),
              labelText: 'Notes',
            ),
            onChanged: (description) => context.read<TransactionBloc>().add(
                  TransactionNotesChanged(description: description),
                ));
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final themeState = context.watch<ThemeCubit>().state;
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ListTile(
          tileColor: state.isValid &&
              state.category != null &&
              state.subcategory != null &&
              state.account != null
              ? themeState.secondaryColor
              : BudgetColors.grey,
                title: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: state.isValid &&
                            state.category != null &&
                            state.subcategory != null &&
                            state.account != null
                            ? BudgetColors.primary
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
