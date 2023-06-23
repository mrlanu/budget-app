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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 70.w, horizontal: 50.w),
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
            ],
          ),
        ),
        Expanded(child: Container()),
        _SubmitButton(),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ListTile(
          tileColor: scheme.primaryContainer,
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
