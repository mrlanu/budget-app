import 'package:budget_app/transfer/transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

import '../../home/cubit/home_cubit.dart';
import '../widgets/to_account_input_field.dart';

class TransferForm extends StatelessWidget {
  const TransferForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 70.w, horizontal: 50.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AmountInput(),
            SizedBox(
              height: 30.h,
            ),
            DateInputField(),
            SizedBox(
              height: 75.h,
            ),
            FromAccountInputField(),
            SizedBox(
              height: 75.h,
            ),
            ToAccountInputField(),
            SizedBox(
              height: 75.h,
            ),
            NotesInputField(),
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

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
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
                        state.fromAccount != null &&
                        state.toAccount != null
                    ? () => context
                        .read<TransferBloc>()
                        .add(TransferFormSubmitted(context: context))
                    : null,
                child: Text('SAVE'),
              );
      },
    );
  }
}
