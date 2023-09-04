import 'package:budget_app/home/cubit/home_cubit.dart';
import 'package:budget_app/transactions/models/transaction_type.dart';
import 'package:budget_app/transactions/models/transactions_view_filter.dart';
import 'package:budget_app/transactions/transaction/bloc/transaction_bloc.dart';
import 'package:budget_app/transactions/view/widgets/transaction_list_tile.dart';
import 'package:budget_app/transfer/bloc/transfer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';
import '../../transfer/view/transfer_page.dart';
import '../cubit/transactions_cubit.dart';
import '../transaction/view/transaction_page.dart';

class TransactionsList extends StatelessWidget {
  final TransactionsViewFilter filter;

  const TransactionsList({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsCubit, TransactionsState>(
      builder: (context, state) {
        state = state.copyWith(filter: filter);
        final maxHeight = h * 0.55;
        return state.status == TransactionsStatus.loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin: EdgeInsets.only(bottom: 10),
                height: state.filteredTiles.length * 80 > maxHeight
                    ? maxHeight
                    : state.filteredTiles.length * 80,
                child: ListView.separated(
                    itemCount: state.filteredTiles.length,
                    itemBuilder: (context, index) {
                      final tr = state.filteredTiles[state.filteredTiles.length - index - 1];
                      return TransactionListTile(
                        transactionTile: tr,
                        onDismissed: (_) {
                          final trCub = context.read<TransactionsCubit>();
                          tr.type == TransactionType.TRANSFER
                              ? trCub.deleteTransfer(transferId: tr.id)
                              : trCub.deleteTransaction(transactionId: tr.id);
                        },
                        onTap: () => {
                          if (tr.type == TransactionType.TRANSFER)
                            {
                              isDisplayDesktop(context)
                                  ? context.read<TransferBloc>().add(
                                      TransferFormLoaded(transactionTile: tr))
                                  : Navigator.of(context).push(
                                      TransferPage.route(
                                          homeCubit: context.read<HomeCubit>(),
                                          transactionTile: tr),
                                    )
                            }
                          else
                            {
                              isDisplayDesktop(context)
                                  ? context.read<TransactionBloc>().add(
                                        TransactionFormLoaded(
                                            transactionType: tr.type,
                                            transaction: tr,
                                            date: context
                                                .read<HomeCubit>()
                                                .state
                                                .selectedDate!),
                                      )
                                  : Navigator.of(context).push(
                                      TransactionPage.route(
                                          transaction: tr,
                                          homeCubit: context.read<HomeCubit>(),
                                          transactionType: tr.type,
                                          date: context
                                              .read<HomeCubit>()
                                              .state
                                              .selectedDate!),
                                    )
                            }
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        Divider(indent: 30, endIndent: 30)),
              );
      },
    );
  }
}
