import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transfer_bloc.dart';

class NotesInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notes = context.select((TransferBloc bloc) => bloc.state.notes);
    return TextFormField(
        initialValue: notes,
        decoration: InputDecoration(
          icon: Icon(
            Icons.notes,
            color: Colors.orangeAccent,
          ),
          border: OutlineInputBorder(),
          labelText: 'Notes',
        ),
        onChanged: (notes) => context.read<TransferBloc>().add(
              TransferNotesChanged(notes: notes),
            ));
  }
}
