import 'package:qruto_budget/transfer/transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

import '../../constants/colors.dart';
import '../../constants/constants.dart';
import '../../utils/theme/cubit/theme_cubit.dart';
import '../widgets/to_account_input_field.dart';

class TransferForm extends StatelessWidget {
  const TransferForm({Key? key}) : super(key: key);

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

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        final themeState = context.watch<ThemeCubit>().state;
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : state.isValid &&
                    state.fromAccount != null &&
                    state.toAccount != null
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: themeState.secondaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 14),
                    ),
                    onPressed: () => context
                        .read<TransferBloc>()
                        .add(TransferFormSubmitted(context: context)),
                    child: SizedBox(
                      width: 150.w,
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
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
