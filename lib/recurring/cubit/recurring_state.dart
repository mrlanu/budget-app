part of 'recurring_cubit.dart';

enum RecurringStatus { initial, success }

class RecurringState extends Equatable {
  const RecurringState({
    this.status = RecurringStatus.initial,
    this.items = const [],
  });

  final RecurringStatus status;
  final List<RecurringTransactionWithDetails> items;

  RecurringState copyWith({
    RecurringStatus? status,
    List<RecurringTransactionWithDetails>? items,
  }) {
    return RecurringState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [status, items];
}
