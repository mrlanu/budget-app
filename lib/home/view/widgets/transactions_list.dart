import 'package:budget_app/transfer/bloc/transfer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/constants.dart';
import '../../../transaction/transaction.dart';
import '../../home.dart';

class TransactionsList extends StatelessWidget {
  final List<ComprehensiveTransaction> transactionTiles;

  const TransactionsList({super.key, required this.transactionTiles});

  @override
  Widget build(BuildContext context) {
    final maxHeight = h * 0.55;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: transactionTiles.length * 80 > maxHeight
          ? maxHeight
          : transactionTiles.length * 80,
      child: ListView.separated(
          itemCount: transactionTiles.length,
          itemBuilder: (context, index) {
            final tr = transactionTiles[transactionTiles.length - index - 1];
            return TransactionListTile(
              transactionTile: tr,
              onDismissed: (_) {
                final trCub = context.read<HomeCubit>();
                trCub.deleteTransaction(transaction: tr);
              },
              onTap: () => {
                if (tr.type == TransactionType.TRANSFER)
                  {
                    isDisplayDesktop(context)
                        ? context
                            .read<TransferBloc>()
                            .add(TransferFormLoaded(transaction: tr))
                        : context.push('/transfer/${tr.id}')
                  }
                else
                  {
                    isDisplayDesktop(context)
                        ? context.read<TransactionBloc>().add(
                              TransactionFormLoaded(
                                transactionType: tr.type,
                              ),
                            )
                        : context.push(
                            '/transaction/${tr.id}?typeIndex=${tr.type.index}')
                  }
              },
            );
          },
          separatorBuilder: (context, index) =>
              Divider(indent: 30, endIndent: 30)),
    );
  }
}
