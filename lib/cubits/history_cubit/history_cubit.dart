import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';
import '../../repositories/history_repository.dart';
import '../../repositories/products_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository historyRepository;
  final ProductsRepository productsRepository;
  late final StreamSubscription _subscription;

  HistoryCubit({
    required this.historyRepository,
    required this.productsRepository,
  }) : super(HistoryInitial()) {
    _subscribe();
  }

  void _subscribe() {
    _subscription = historyRepository.history.listen(
      (items) {
        if (historyRepository.isSessionOpened) {
          List<HistoryAction> undoHistory = items.toList();
          undoHistory.removeWhere((element) => element.isRedo == true);
          emit(
            HistoryLoaded(
              history: undoHistory,
              canUndo: historyRepository.canUndo(),
              canRedo: historyRepository.canRedo(),
            ),
          );
        } else {
          emit(HistoryInitial());
        }
      },
      //TODO onError: (error) => emit(ListError('$error')),
    );
  }

  void undo() {
    final HistoryAction? undoAction = historyRepository.undo();
    if (undoAction != null) {
      if (undoAction.oldProduct == null && undoAction.updatedProduct != null) {
        productsRepository.deleteProduct(undoAction.updatedProduct!.id);
      } else if (undoAction.oldProduct != null &&
          undoAction.updatedProduct == null) {
        productsRepository.addProduct(undoAction.oldProduct!);
      } else {
        productsRepository.updateProduct(undoAction.oldProduct!);
      }
    }
  }

  void redo() {
    final HistoryAction? redoAction = historyRepository.redo();
    if (redoAction != null) {
      if (redoAction.oldProduct == null && redoAction.updatedProduct != null) {
        productsRepository.addProduct(redoAction.updatedProduct!);
      } else if (redoAction.oldProduct != null &&
          redoAction.updatedProduct == null) {
        productsRepository.deleteProduct(redoAction.oldProduct!.id);
      } else {
        productsRepository.updateProduct(redoAction.updatedProduct!);
      }
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
