import 'dart:async';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';

class SessionRepository {
  final HiveInterface hiveInterface;
  final _controller = StreamController<List<Session>>();
  final int maxStoredSessions;

  SessionRepository({
    required this.hiveInterface,
    this.maxStoredSessions = 10,
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
    if (_sessions.isNotEmpty && _sessions.length >= maxStoredSessions) {
      _sessionsBox!.deleteAt(0);
      _sessions.removeAt(0);
    }
    _sessions.add(newSession);
    await _sessionsBox!.put(newSession.id, newSession);
    addToStream(_sessions);
    return Session(id: '', startDate: DateTime.now());
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

  void endSession(String id) {
    Session? session = findById(id);
    if (session != null) {
      session = session.copyWith(endDate: DateTime.now());
      updateSession(session);
    }
  }

  Session? restoreSession(String id) {
    Session? session = findById(id);
    if (session != null) {
      session = session.copyWith(endDate: null);
      updateSession(session);
    }
    return session;
  }
}
