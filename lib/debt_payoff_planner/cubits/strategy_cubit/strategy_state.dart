part of 'strategy_cubit.dart';

abstract class StrategyState extends Equatable {}

class LoadingStrategyState extends StrategyState {
  @override
  List<Object?> get props => [];
}

class LoadedStrategyState extends StrategyState {
  final String strategy;
  final String extraPayment;
  final DebtPayoffStrategy debtPayoffStrategy;

  LoadedStrategyState(
      {this.strategy = 'snowball',
      this.extraPayment = '0',
      required this.debtPayoffStrategy});

  @override
  List<Object?> get props => [strategy, extraPayment, debtPayoffStrategy];
}
