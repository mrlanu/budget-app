import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

import '../../utils/theme/budget_theme.dart';
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
                  height: 50,
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
    final description =
        context.select((TransactionBloc bloc) => bloc.state.description);
    final colors = context.read<ThemeCubit>().state;
    return TextFormField(
        initialValue: description,
        decoration: InputDecoration(
          icon: Icon(
            Icons.notes,
            color: BudgetTheme.isDarkMode(context)
                ? Colors.white
                : colors.primaryColor[900],
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
    final colors = context.read<ThemeCubit>().state;
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final themeState = context.watch<ThemeCubit>().state;
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : state.isValid &&
                    state.category != null &&
                    state.subcategory != null &&
                    state.account != null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: themeState.secondaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 14),
                    ),
                    onPressed: () => context
                        .read<TransactionBloc>()
                        .add(TransactionFormSubmitted(context: context)),
                    child: SizedBox(
                      width: 150.w,
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: colors.primaryColor[500],
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ))
                : SizedBox();
      },
    );
  }
}
