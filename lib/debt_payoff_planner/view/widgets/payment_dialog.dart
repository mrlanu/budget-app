import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../database/database.dart';
import '../../../utils/theme/cubit/theme_cubit.dart';
import '../../cubits/debt_cubit/debts_cubit.dart';

class PaymentDialog extends StatefulWidget {
  final Debt debt;
  final Payment? payment;

  const PaymentDialog({super.key, required this.debt, this.payment});

  bool get isEditing => payment != null;

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late final TextEditingController _amountController;
  late DateTime _date;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _amountController = TextEditingController(
        text: widget.payment!.amount.toStringAsFixed(2),
      );
      _date = widget.payment!.date;
    } else {
      final defaultAmount =
          widget.debt.currentBalance < widget.debt.minimumPayment
              ? widget.debt.currentBalance
              : widget.debt.minimumPayment;
      _amountController =
          TextEditingController(text: defaultAmount.toStringAsFixed(2));
      _date = DateTime.now();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _maxAmount {
    if (widget.isEditing) {
      return widget.debt.currentBalance + widget.payment!.amount;
    }
    return widget.debt.currentBalance;
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a valid payment amount');
      return;
    }
    if (amount > _maxAmount + 0.001) {
      setState(() => _error = 'Amount cannot exceed remaining balance');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final cubit = context.read<DebtsCubit>();
      if (widget.isEditing) {
        await cubit.updatePayment(
          paymentId: widget.payment!.id,
          amount: amount,
          date: _date,
        );
      } else {
        await cubit.recordPayment(
          debtId: widget.debt.id,
          amount: amount,
          date: _date,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = widget.isEditing
              ? 'Failed to update payment'
              : 'Failed to record payment';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.read<ThemeCubit>().state;
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isEditing ? 'Edit payment' : 'Record payment',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.debt.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                icon:
                    Icon(Icons.attach_money, color: themeState.secondaryColor),
                border: const OutlineInputBorder(),
                labelText: 'Amount',
                errorText: _error,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today,
                      color: themeState.secondaryColor),
                  border: const OutlineInputBorder(),
                  labelText: 'Payment date',
                ),
                child: Text(DateFormat('MM-dd-yyyy').format(_date)),
              ),
            ),
            const SizedBox(height: 24),
            _submitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: themeState.secondaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _submit,
                    child: Text(widget.isEditing ? 'SAVE' : 'SAVE PAYMENT'),
                  ),
          ],
        ),
      ),
    );
  }
}
