part of 'strategy_cubit.dart';

enum StrategyStateStatus { loading, success, failure }

class StrategyState extends Equatable {
  static const snowball = 'Snowball';
  static const avalanche = 'Avalanche';

  final String strategy;
  final String extraPayment;
  final DebtPayoffStrategy? debtPayoffStrategy;
  final StrategyStateStatus status;
  final String? errorMessage;

  StrategyState({
    this.strategy = snowball,
    this.extraPayment = '0',
    this.debtPayoffStrategy,
    this.status = StrategyStateStatus.loading,
    this.errorMessage,
  });

  StrategyState copyWith({
    String? strategy,
    String? extraPayment,
    DebtPayoffStrategy? debtPayoffStrategy,
    StrategyStateStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StrategyState(
      strategy: strategy ?? this.strategy,
      extraPayment: extraPayment ?? this.extraPayment,
      debtPayoffStrategy: debtPayoffStrategy ?? this.debtPayoffStrategy,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props =>
      [strategy, extraPayment, debtPayoffStrategy, status, errorMessage];
}
