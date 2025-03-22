import 'package:animations/animations.dart';
import 'package:qruto_budget/transfer/transfer.dart';
import 'package:qruto_budget/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transaction/transaction.dart';
import '../../home.dart';

class TransactionsList extends StatelessWidget {
  final List<TransactionTile> transactionTiles;

  TransactionsList({super.key, required this.transactionTiles});

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final h = MediaQuery.of(context).size.height;
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
            return OpenContainer<bool>(
              useRootNavigator: true,
              closedColor: themeState.primaryColor[100]!,
              transitionType: _transitionType,
              openBuilder: (BuildContext _, VoidCallback openContainer) {
                return tr.type == TransactionType.TRANSFER
                    ? TransferPage(
                        transactionId: tr.id,
                      )
                    : TransactionPage(transactionId: tr.id, transactionType: tr.type,);
              },
              tappable: true,
              closedShape: const RoundedRectangleBorder(),
              closedElevation: 0.0,
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return TransactionListTile(
                  transactionTile: tr,
                  onDismissed: (_) {
                    final trCub = context.read<HomeCubit>();
                    trCub.deleteTransaction(transactionId: tr.id);
                  },
                  onTap: openContainer,
                );
              },
            );
          },
          separatorBuilder: (context, index) =>
              Divider(indent: 30, endIndent: 30)),
    );
  }
}
