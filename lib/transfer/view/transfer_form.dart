import 'package:budget_app/constants/colors.dart';
import 'package:budget_app/transfer/transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../constants/constants.dart';
import '../widgets/to_account_input_field.dart';

class TransferForm extends StatelessWidget {
  const TransferForm({Key? key}) : super(key: key);

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
                  height: 0,
                ),
                DateInputField(),
                SizedBox(
                  height: 20,
                ),
                FromAccountInputField(),
                SizedBox(
                  height: 20,
                ),
                ToAccountInputField(),
                SizedBox(
                  height: 20,
                ),
                NotesInputField(),
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

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ListTile(
                tileColor: state.isValid &&
                        state.fromAccount != null &&
                        state.toAccount != null
                    ? BudgetColors.accent
                    : BudgetColors.grey,
                title: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: state.isValid &&
                                state.fromAccount != null &&
                                state.toAccount != null
                            ? Colors.black
                            : Colors.grey,
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize),
                  ),
                ),
                onTap: state.isValid &&
                        state.fromAccount != null &&
                        state.toAccount != null
                    ? () => context
                        .read<TransferBloc>()
                        .add(TransferFormSubmitted(context: context))
                    : null,
              );
      },
    );
  }
}
