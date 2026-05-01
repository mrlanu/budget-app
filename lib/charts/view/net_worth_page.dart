import 'package:qruto_budget/charts/repository/chart_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/net_worth_cubit.dart';
import 'net_worth_table.dart';
import 'widgets/include_hidden_accounts_switch.dart';
import 'widgets/net_worth_chart_panel.dart';

class NetWorthPage extends StatelessWidget {
  const NetWorthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NetWorthCubit(chartRepository: context.read<ChartRepository>())
            ..load(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Net worth',
            style: TextStyle(fontSize: 30.sp),
          ),
        ),
        body: BlocBuilder<NetWorthCubit, NetWorthState>(
          builder: (context, state) {
            if (state.status == NetWorthStatus.failure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.errorMessage ?? 'Something went wrong',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.read<NetWorthCubit>().load(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final loading = state.status == NetWorthStatus.loading ||
                state.status == NetWorthStatus.initial;
            final bootLoading = loading && state.points.isEmpty;
            if (bootLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final refreshing = loading && state.points.isNotEmpty;

            return Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.25 / 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    child: refreshing
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : NetWorthChartPanel(points: state.points),
                  ),
                ),
                const IncludeHiddenAccountsSwitch(),
                Expanded(
                  child: refreshing
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const NetWorthTable(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
