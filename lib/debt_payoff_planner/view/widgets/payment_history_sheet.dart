import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../database/database.dart';
import '../../cubits/debt_cubit/debts_cubit.dart';
import 'payment_dialog.dart';

class PaymentHistorySheet extends StatefulWidget {
  final Debt debt;

  const PaymentHistorySheet({super.key, required this.debt});

  @override
  State<PaymentHistorySheet> createState() => _PaymentHistorySheetState();
}

class _PaymentHistorySheetState extends State<PaymentHistorySheet> {
  Future<List<Payment>>? _paymentsFuture;

  void _reload() {
    _paymentsFuture =
        context.read<DebtsCubit>().paymentsForDebt(widget.debt.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _paymentsFuture ??=
        context.read<DebtsCubit>().paymentsForDebt(widget.debt.id);
  }

  Debt get _latestDebt {
    final debts = context.read<DebtsCubit>().state.debtList;
    return debts.firstWhere(
      (d) => d.id == widget.debt.id,
      orElse: () => widget.debt,
    );
  }

  Future<void> _editPayment(Payment payment) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<DebtsCubit>(),
        child: PaymentDialog(debt: _latestDebt, payment: payment),
      ),
    );
    if (changed == true && mounted) {
      setState(_reload);
    }
  }

  Future<void> _deletePayment(Payment payment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete payment?'),
        content: Text(
          'Remove the \$${payment.amount.toStringAsFixed(2)} payment from '
          '${DateFormat('MM-dd-yyyy').format(payment.date)}? '
          'The amount will be added back to the debt balance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await context.read<DebtsCubit>().deletePayment(paymentId: payment.id);
    if (mounted) setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Payments — ${widget.debt.name}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Flexible(
              child: FutureBuilder<List<Payment>>(
                future: _paymentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final payments = snapshot.data ?? [];
                  if (payments.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No payments recorded yet.')),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: payments.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '\$ ${payment.amount.toStringAsFixed(2)}',
                        ),
                        subtitle: Text(
                          DateFormat('MM-dd-yyyy').format(payment.date),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _editPayment(payment),
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deletePayment(payment),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
