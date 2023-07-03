import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/transaction_bloc.dart';

class DateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      buildWhen: (previous, current) => previous.date != current.date,
      builder: (context, state) {
        return TextFormField(
            controller: TextEditingController(
                text: state.date != null
                    ? DateFormat('MM-dd-yyyy').format(state.date!)
                    : DateFormat('MM-dd-yyyy').format(DateTime.now())),
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(
                  Icons.calendar_today,
                  color: Color(0xFFEAAA00),
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
      },
    );
  }
}
