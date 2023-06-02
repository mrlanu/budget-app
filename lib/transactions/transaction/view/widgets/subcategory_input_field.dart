import 'package:budget_app/subcategories/view/subcategories_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/models/subcategory.dart';
import '../../bloc/transaction_bloc.dart';

class SubcategoryInput extends StatefulWidget {
  @override
  State<SubcategoryInput> createState() => _SubcategoryInputState();
}

class _SubcategoryInputState extends State<SubcategoryInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      //buildWhen: (previous, current) => previous.selectedSubcategory != current.selectedSubcategory,
      builder: (context, state) {
        return DropdownButtonFormField<Subcategory>(
            icon: GestureDetector(
              child: Icon(Icons.edit_note),
              onTap: state.category != null ? () {
                Navigator.of(context).push(SubcategoriesPage.route(category: state.category!));
              } : null,
            ),
            items: state.subcategories.map((Subcategory subcategory) {
              return DropdownMenuItem(
                value: subcategory,
                child: Text(subcategory.name),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransactionBloc>()
                  .add(TransactionSubcategoryChanged(subcategory: newValue));
              //setState(() => selectedValue = newValue);
            },
            value: state.subcategory,
            decoration: InputDecoration(
              icon: Icon(
                Icons.category_outlined,
                color: Colors.orangeAccent,
              ),
              border: OutlineInputBorder(),
              labelText: 'Subcategory',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }

  /*Future<String?> _openDialog(BuildContext context) => showDialog<String>(
      context: context,
      builder: (_) => BlocProvider.value(
          value: context.read<TransactionBloc>(),
          child: AlertDialog(
            title: Text(
                'Add subcategory to ${context.read<TransactionBloc>().state.category?.name} category'),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Enter name'),
            ),
            actions: [
              TextButton(
                onPressed: () => _submit(context),
                child: Text('SAVE'),
              )
            ],
          )));

  void _submit(BuildContext context) {
    context
        .read<TransactionBloc>()
        .add(TransactionSubcategoryCreated(name: _controller.text));
    Navigator.of(context).pop(_controller.text);
    _controller.clear();
  }*/
}
