part of 'overview_bloc.dart';

abstract class OverviewEvent extends Equatable {
  const OverviewEvent();
}

class LoadCategoriesEvent extends OverviewEvent{

  @override
  List<Object?> get props => [];

}

class CategoriesLoadedEvent extends OverviewEvent{

  @override
  List<Object?> get props => [];

}
