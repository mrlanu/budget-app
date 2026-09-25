import 'package:qruto_budget/debt_payoff_planner/cubits/debt_cubit/debts_cubit.dart';
import 'package:qruto_budget/debt_payoff_planner/debt_form/debt_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

import '../../../utils/theme/cubit/theme_cubit.dart';

class DebtDialog extends StatelessWidget {
  const DebtDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DebtBloc, DebtState>(
      listener: (context, state) {
        if (state.submissionStatus.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Save failed'),
              ),
            );
        }
        if (state.submissionStatus.isSuccess) {
          context.read<DebtsCubit>().updateDebts();
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return state.status == DebtStateStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : Dialog(
                insetPadding: const EdgeInsets.all(10),
                child: Container(
                  height: 560,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          state.id == null ? 'Add Debt' : 'Edit Debt',
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.fontSize,
                          ),
                        ),
                        const SizedBox(height: 15),
                        NameInputField(),
                        const SizedBox(height: 20),
                        BalanceInput(),
                        const SizedBox(height: 20),
                        MinInputField(),
                        const SizedBox(height: 20),
                        AprInputField(),
                        const SizedBox(height: 20),
                        const _DueDateField(),
                        const SizedBox(height: 20),
                        _SubmitButton(),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class _DueDateField extends StatelessWidget {
  const _DueDateField();

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return BlocBuilder<DebtBloc, DebtState>(
      buildWhen: (previous, current) =>
          previous.nextPaymentDue != current.nextPaymentDue,
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: state.nextPaymentDue,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null && context.mounted) {
              context.read<DebtBloc>().add(DueDateChanged(dueDate: picked));
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              icon: Icon(Icons.calendar_today, color: themeState.secondaryColor),
              border: const OutlineInputBorder(),
              labelText: 'Next payment due',
            ),
            child: Text(
              DateFormat('MM-dd-yyyy').format(state.nextPaymentDue),
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebtBloc, DebtState>(
      builder: (context, state) {
        final themeState = context.read<ThemeCubit>().state;
        return state.submissionStatus.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: themeState.secondaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: state.isValid
                    ? () =>
                        context.read<DebtBloc>().add(const DebtFormSubmitted())
                    : null,
                child: Text(state.id == null ? 'ADD' : 'SAVE'),
              );
      },
    );
  }
}
