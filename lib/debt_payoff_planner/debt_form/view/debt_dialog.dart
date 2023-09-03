import 'package:budget_app/colors.dart';
import 'package:budget_app/debt_payoff_planner/cubits/debt_cubit/debts_cubit.dart';
import 'package:budget_app/debt_payoff_planner/debt_form/debt_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

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
                content: Text(state.errorMessage ?? 'Add Failure'),
              ),
            );
        }
        if (state.submissionStatus.isSuccess) {
          context.read<DebtsCubit>().updateDebts();
        }
      },
      builder: (context, state) {
        return state.status == DebtStateStatus.loading
            ? Center(child: CircularProgressIndicator())
            : Dialog(
                backgroundColor: BudgetColors.teal50,
                insetPadding: EdgeInsets.all(10),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 500,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),),
                      padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(state.id == null ? 'Add Debt' : 'Edit Debt',
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.fontSize)),
                            SizedBox(height: 15),
                            NameInputField(),
                            SizedBox(height: 20),
                            BalanceInput(),
                            SizedBox(height: 20),
                            MinInputField(),
                            SizedBox(height: 20),
                            AprInputField(),
                            SizedBox(height: 20),
                            _SubmitButton(),
                          ],
                        ),
                      ),
                    ),
                    /*Positioned(
                    top: -100,
                    child: Image.network("https://i.imgur.com/2yaf2wb.png",
                        width: 150, height: 150))*/
                  ],
                ));
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebtBloc, DebtState>(
      //buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.submissionStatus.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                onPressed: state.isValid
                    ? () => context
                        .read<DebtBloc>()
                        .add(DebtFormSubmitted(context: context))
                    : null,
                child: Text(state.id == null ? 'ADD' : 'SAVE')
              );
      },
    );
  }
}
