import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/models/category.dart';
import '../../bloc/transaction_bloc.dart';

class CategoryInput extends StatefulWidget {
  @override
  State<CategoryInput> createState() => _CategoryInputState();
}

class _CategoryInputState extends State<CategoryInput> {
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
      builder: (context, state) {
        return DropdownButtonFormField<Category>(
            icon: GestureDetector(
              child: Icon(Icons.add),
              onTap: (){
                _openDialog(context);
              },
            ),
            items: state.categories.map((Category category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (newValue) {
              context
                  .read<TransactionBloc>()
                  .add(TransactionCategoryChanged(category: newValue));
              //setState(() => selectedValue = newValue);
            },
            value: state.category,
            decoration: InputDecoration(
              icon: Icon(
                Icons.category,
                color: Colors.orangeAccent,
              ),
              border: OutlineInputBorder(),
              labelText: 'Category',
              //errorText: errorSnapshot.data == 0 ? Localization.of(context).categoryEmpty : null),
            ));
      },
    );
  }

  Future<String?> _openDialog(BuildContext context) =>
      showDialog<String>(
          context: context,
          builder: (_) => BlocProvider.value(
              value: context.read<TransactionBloc>(),
              child: AlertDialog(

                title: Text('Add category'),
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
              ))
      );

  void _submit(BuildContext context) {
    context
        .read<TransactionBloc>()
        .add(TransactionCategoryCreated(name: _controller.text));
    Navigator.of(context).pop(_controller.text);
    _controller.clear();
  }
}
