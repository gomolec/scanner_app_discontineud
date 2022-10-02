import 'dart:async';

import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import 'history_repository.dart';
import 'products_repository.dart';

class SessionsRepository {
  final HiveInterface hiveInterface;
  final _controller = BehaviorSubject<List<Session>>();
  final int maxStoredSessions;
  final ProductsRepository productsRepository;
  final HistoryRepository historyRepository;

  SessionsRepository({
    required this.hiveInterface,
    this.maxStoredSessions = 5,
    required this.productsRepository,
    required this.historyRepository,
  });

  Box<Session>? _sessionsBox;

  Stream<List<Session>> get sessions => _controller.stream;

  void addToStream(List<Session> sessions) => _controller.sink.add(sessions);

  Future<Session> createNewSession({required String? author}) async {
    if (_sessionsBox == null) {
      await getSavedSessions();
    }
    final newSession = Session(
      id: const Uuid().v1(),
      startDate: DateTime.now(),
      author: author,
    );
    if (_sessionsBox!.length >= maxStoredSessions) {
      await deleteSession(_sessionsBox!.values.toList().first.id);
    }
    await _sessionsBox!.add(newSession);
    await productsRepository.openProductsSession(newSession.id);
    await historyRepository.openHistorySession(newSession.id);
    addToStream(_sessionsBox!.values.toList());
    return newSession;
  }

  Future<void> getSavedSessions() async {
    _sessionsBox = await hiveInterface.openBox('sessions');
    addToStream(_sessionsBox!.values.toList());
  }

  Session? findById(String id) {
    if (_sessionsBox == null) return null;
    return _sessionsBox!.values
        .toList()
        .cast<Session?>()
        .firstWhere((session) => session!.id == id, orElse: () => null);
  }

  Future<void> deleteSession(String id) async {
    final index = _sessionsBox!.values.toList().indexWhere((it) => it.id == id);
    if (index != -1) {
      await _sessionsBox!.delete(_sessionsBox!.keys.toList()[index]);
      addToStream(_sessionsBox!.values.toList());
      await productsRepository.deleteProductsSession(id);
      await historyRepository.deleteHistorySession(id);
    }
  }

  Future<void> updateSession(Session session) async {
    final index =
        _sessionsBox!.values.toList().indexWhere((it) => it.id == session.id);
    if (index != -1) {
      await _sessionsBox!.put(_sessionsBox!.keys.toList()[index], session);
      addToStream(_sessionsBox!.values.toList());
    }
  }

  Future<void> endSession(String id) async {
    Session? session = findById(id);
    if (session != null) {
      session = session.copyWith(endDate: () => DateTime.now());
      updateSession(session);
      await productsRepository.closeProductsSession();
      await historyRepository.closeHistorySession();
    }
  }

  Future<Session?> restoreSession(String id) async {
    Session? session = findById(id);
    if (session != null) {
      session = session.copyWith(endDate: () => null);
      updateSession(session);
      await productsRepository.openProductsSession(id);
      await historyRepository.openHistorySession(id);
    }
    return session;
  }
}
