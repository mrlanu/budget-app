import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/transfer_bloc.dart';

class DateInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final date = context.select((TransferBloc bloc) => bloc.state.date);
    return TextFormField(
        controller: TextEditingController(
            text: date != null
                ? DateFormat('MM-dd-yyyy').format(date)
                : DateFormat('MM-dd-yyyy').format(DateTime.now())),
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(
              Icons.calendar_today,
              color: Colors.orangeAccent,
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
                .read<TransferBloc>()
                .add(TransferDateChanged(dateTime: pickedDate));
          } else {
            print("Date is not selected");
          }
        });
  }
}
