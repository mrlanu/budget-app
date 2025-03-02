part of 'strategy_cubit.dart';

enum StrategyStateStatus { loading, success, failure }

class StrategyState extends Equatable {
  final String strategy;
  final String extraPayment;
  final DebtPayoffStrategy? debtPayoffStrategy;
  final StrategyStateStatus status;

  StrategyState(
      {this.strategy = 'snowball',
      this.extraPayment = '0',
      this.debtPayoffStrategy,
      this.status = StrategyStateStatus.loading});

  StrategyState copyWith({
    String? strategy,
    String? extraPayment,
    DebtPayoffStrategy? debtPayoffStrategy,
    StrategyStateStatus? status,
}){
    return StrategyState(
      strategy: strategy ?? this.strategy,
      extraPayment: extraPayment ?? this.extraPayment,
      debtPayoffStrategy: debtPayoffStrategy ?? this.debtPayoffStrategy,
      status: status ?? this.status
    );
}

  @override
  List<Object?> get props =>
      [strategy, extraPayment, debtPayoffStrategy, status];
}
