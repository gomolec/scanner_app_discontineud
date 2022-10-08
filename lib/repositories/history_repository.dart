import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../models/models.dart';

class HistoryRepository {
  final HiveInterface hiveInterface;
  final _controller = BehaviorSubject<List<HistoryAction>>();
  final int maxStoredHistoryActions;

  HistoryRepository({
    required this.hiveInterface,
    this.maxStoredHistoryActions = 5,
  });

  Box<HistoryAction>? _historyBox;
  List<HistoryAction> _history = [];
  int currentActivityIndex = -1;

  Stream<List<HistoryAction>> get history => _controller.stream;
  bool get isSessionOpened => _historyBox != null;

  void addToStream(List<HistoryAction> history) =>
      _controller.sink.add(history);

  Future<void> openHistorySession(String id) async {
    if (_historyBox != null) {
      await closeHistorySession();
    }
    _historyBox = await Hive.openBox("history-$id");
    _history = _historyBox!.values.toList();
    currentActivityIndex = -1;
    if (_history.isNotEmpty) {
      currentActivityIndex =
          _history.lastIndexWhere((element) => element.isRedo == false);
    }
    addToStream(_history);
  }

  Future<void> closeHistorySession() async {
    if (_historyBox != null) {
      await _historyBox!.close();
      _historyBox = null;
    }
    _history = [];
    addToStream(_history);
  }

  Future<void> deleteHistorySession(String id) async {
    if (_historyBox != null && _historyBox!.name == "history-$id") {
      await closeHistorySession();
    }
    hiveInterface.deleteBoxFromDisk("history-$id");
  }

  void addActivity(Product? oldProduct, Product? updatedProduct) {
    if (oldProduct != updatedProduct) {
      int id = 0;
      if (currentActivityIndex > -1) {
        id = _history.last.id + 1;
      }
      currentActivityIndex++;
      if (_history.length > currentActivityIndex) {
        for (var i = _history.length - 1; i >= currentActivityIndex; i--) {
          _history.removeAt(i);
          _historyBox!.deleteAt(i);
        }
      }
      if (currentActivityIndex >= maxStoredHistoryActions) {
        _history.removeAt(0);
        _historyBox!.deleteAt(0);
        currentActivityIndex--;
      }
      final HistoryAction action = HistoryAction(
        id: id,
        oldProduct: oldProduct,
        updatedProduct: updatedProduct,
      );
      _history.add(action);
      _historyBox!.put(id, action);
      addToStream(_history);
    }
  }

  HistoryAction? undo() {
    if (_history.isNotEmpty && _history.first.isRedo == false) {
      final HistoryAction action =
          _history[currentActivityIndex].copyWith(isRedo: true);
      _history[currentActivityIndex] = action;
      _historyBox!.put(action.id, action);
      currentActivityIndex--;
      addToStream(_history);
      return action;
    }
    return null;
  }

  HistoryAction? redo() {
    if (_history.isNotEmpty && _history.last.isRedo == true) {
      currentActivityIndex++;
      final HistoryAction action =
          _history[currentActivityIndex].copyWith(isRedo: false);
      _history[currentActivityIndex] = action;
      _historyBox!.put(action.id, action);
      addToStream(_history);
      return action;
    }
    return null;
  }

  bool canUndo() {
    if (_history.isNotEmpty) {
      if (_history.first.isRedo == false) return true;
    }
    return false;
  }

  bool canRedo() {
    if (_history.isNotEmpty) {
      if (_history.last.isRedo == true) return true;
    }
    return false;
  }
}
