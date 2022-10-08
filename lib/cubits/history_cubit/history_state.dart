part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryAction> history;
  final bool canUndo;
  final bool canRedo;

  const HistoryLoaded({
    required this.history,
    required this.canUndo,
    required this.canRedo,
  });

  @override
  List<Object> get props => [history, canUndo, canRedo];
}
