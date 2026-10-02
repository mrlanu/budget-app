import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qruto_budget/database/transaction_with_detail.dart';
import 'package:qruto_budget/transaction/models/transaction_type.dart';

import '../constants/changelog.dart';
import '../utils/theme/cubit/theme_cubit.dart';

class SharedFunctions {
  static void showSnackbar(
      BuildContext context, bool success, String title, String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: success ? ContentType.success : ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showWhatsNewSheet(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final prColor = context.read<ThemeCubit>().state.primaryColor;
        return Container(
          height: 600,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40),
          child: SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What's New",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...changelog.map((item) {
                        final isTitle =
                            (item['titles'] as List<dynamic>).isNotEmpty;
                        final isAdded =
                            (item['added'] as List<dynamic>).isNotEmpty;
                        final isFixed =
                            (item['fixed'] as List<dynamic>).isNotEmpty;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                              // Padding inside the box
                              decoration: BoxDecoration(
                                color: prColor[100], // Background color
                                borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                              ),
                              child: Text(
                                item['version'] as String,
                                // Assuming `item` has a `version` field
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            Text(
                              item['date'] as String,
                              // Assuming `item` has a `version` field
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            isTitle
                                ? RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      height: 1.5,
                                      fontSize: 20,
                                      color: Colors.black),
                                  children:
                                  (item['titles'] as List<String>)
                                      .map<TextSpan>((change) =>
                                      TextSpan(text: '$change\n'))
                                      .toList()),
                            )
                                : Container(),
                            isAdded
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text('Added:',
                                    // Assuming `item` has a `version` field
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            height: 1.5),
                                        children: (item['added']
                                        as List<String>)
                                            .map<TextSpan>((change) =>
                                            TextSpan(
                                                text: ' - $change\n'))
                                            .toList())),
                              ],
                            )
                                : Container(),
                            isFixed
                                ? Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fixed:',
                                  // Assuming `item` has a `version` field
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            height: 1.5,
                                            fontSize: 20,
                                            color: Colors.black),
                                        children: (item['fixed']
                                        as List<String>)
                                            .map<TextSpan>((change) =>
                                            TextSpan(
                                                text: ' - $change\n'))
                                            .toList()))
                              ],
                            )
                                : Container(),
                            Divider(),
                            SizedBox(height: 15),
                          ],
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showRecurringAddedSheet(
    BuildContext context,
    List<TransactionWithDetails> transactions, {
    String title = 'Added recently',
  }) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final prColor = context.read<ThemeCubit>().state.primaryColor;
        final scheme = Theme.of(context).colorScheme;
        final dateFormat = DateFormat.yMMMd();
        final count = transactions.length;

        return Container(
          height: 600,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      count == 0
                          ? 'No recurring transactions were added recently'
                          : count == 1
                              ? '1 transaction was added to your budget'
                              : '$count transactions were added to your budget',
                      style: TextStyle(
                        fontSize: 16,
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Expanded(
                child: count == 0
                    ? Center(
                        child: Text(
                          'Nothing here yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: scheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        itemCount: transactions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          final isIncome = tx.type == TransactionType.INCOME;
                          final categoryName =
                              tx.category?.name ?? 'Uncategorized';
                          final subcategoryName = tx.subcategory?.name;
                          final notes = tx.description.trim();

                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: prColor[100]?.withValues(alpha: 0.55) ??
                                  scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  isIncome
                                      ? Icons.arrow_upward_rounded
                                      : Icons.arrow_downward_rounded,
                                  color: isIncome
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\$${tx.amount.toStringAsFixed(2)} · '
                                        '${isIncome ? 'Income' : 'Expense'}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        subcategoryName == null
                                            ? categoryName
                                            : '$categoryName · $subcategoryName',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: scheme.onSurface,
                                        ),
                                      ),
                                      Text(
                                        '${tx.fromAccount.name} · ${dateFormat.format(tx.date)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: scheme.onSurface
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                      if (notes.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          notes,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: scheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}


