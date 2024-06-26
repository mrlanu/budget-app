import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../transaction.dart';

class DateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final date = context.select((TransactionBloc bloc) => bloc.state.date);
    return TextFormField(
        controller: TextEditingController(
            text: date != null
                ? DateFormat('MM-dd-yyyy').format(date)
                : DateFormat('MM-dd-yyyy').format(DateTime.now())),
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(
              Icons.calendar_today,
              color: themeState.secondaryColor,
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
  }
}
