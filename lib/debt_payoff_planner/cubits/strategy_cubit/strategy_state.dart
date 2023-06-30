part of 'strategy_cubit.dart';

abstract class StrategyState extends Equatable {}

class LoadingStrategyState extends StrategyState {
  @override
  List<Object?> get props => [];
}

class LoadedStrategyState extends StrategyState {

  final DebtPayoffStrategy debtPayoffStrategy;

  LoadedStrategyState({required this.debtPayoffStrategy});

  @override
  List<Object?> get props => [debtPayoffStrategy];
}
