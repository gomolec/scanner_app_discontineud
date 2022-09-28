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
  List<Session> _sessions = [];

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
    if (_sessions.length >= maxStoredSessions) {
      _sessionsBox!.delete(_sessions.removeAt(0).id);
    }
    _sessions.add(newSession);
    await _sessionsBox!.put(newSession.id, newSession);
    await productsRepository.openProductsSession(newSession.id);
    await historyRepository.openHistorySession(newSession.id);
    addToStream(_sessions);
    return newSession;
  }

  Future<void> getSavedSessions() async {
    _sessionsBox = await hiveInterface.openBox('sessions');
    _sessions = _sessionsBox!.values.toList();
    addToStream(_sessions);
  }

  Session? findById(String id) {
    return _sessions
        .cast<Session?>()
        .firstWhere((session) => session!.id == id, orElse: () => null);
  }

  void deleteSession(String id) {
    final index = _sessions.indexWhere((it) => it.id == id);
    if (index != -1) {
      _sessions.removeAt(index);
      addToStream(_sessions);
      _sessionsBox!.delete(id);
      productsRepository.deleteProductsSession(id);
      historyRepository.deleteHistorySession(id);
    }
  }

  void updateSession(Session session) {
    final index = _sessions.indexWhere((it) => it.id == session.id);
    if (index != -1) {
      _sessions[index] = session;
      addToStream(_sessions);
      _sessionsBox!.put(session.id, session);
    }
  }

  Future<void> endSession(String id) async {
    Session? session = findById(id);
    if (session != null) {
      session = session.copyWith(endDate: DateTime.now());
      updateSession(session);
      await productsRepository.closeProductsSession();
      await historyRepository.closeHistorySession();
    }
  }

  Future<Session?> restoreSession(String id) async {
    Session? session = findById(id);
    if (session != null) {
      session = session.copyWith(endDate: null);
      updateSession(session);
      await productsRepository.openProductsSession(id);
      await historyRepository.openHistorySession(id);
    }
    return session;
  }
}
