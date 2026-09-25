import 'package:qruto_budget/debt_payoff_planner/view/widgets/debt_tile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../database/database.dart';
import '../../cubits/debt_cubit/debts_cubit.dart';

class DebtCarousel extends StatefulWidget {
  final void Function(Debt) onEdit;
  final void Function(Debt) onRecordPayment;
  final void Function(Debt) onViewHistory;

  const DebtCarousel({
    super.key,
    required this.onEdit,
    required this.onRecordPayment,
    required this.onViewHistory,
  });

  @override
  State<StatefulWidget> createState() => _DebtCarouselState();
}

class _DebtCarouselState extends State<DebtCarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DebtsCubit, DebtsState>(
      builder: (context, state) {
        if (state.status == DebtsStatus.loading) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.debtList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 12),
                Text(
                  'No debts yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap + to add a debt and build your payoff plan.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        final items = state.debtList
            .map(
              (debt) => DebtTile(
                debtModel: debt,
                lastPayment: state.lastPayments[debt.id],
                onEdit: widget.onEdit,
                onRecordPayment: widget.onRecordPayment,
                onViewHistory: widget.onViewHistory,
              ),
            )
            .toList();

        return Column(
          children: [
            CarouselSlider(
              items: items,
              carouselController: _controller,
              options: CarouselOptions(
                height: 270,
                autoPlay: false,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: items.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withValues(alpha: _current == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
