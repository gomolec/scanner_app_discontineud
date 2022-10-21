import 'dart:async';

import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../services/export_service.dart';
import '../services/import_service.dart';
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

  Future<void> importSession() async {
    final Map? importedSessionData =
        await ImportService().importSessionFromJson();

    if (importedSessionData != null) {
      await _sessionsBox!.add(importedSessionData["session"]);

      await productsRepository.importProductsSession(
        id: importedSessionData["session"].id,
        importedProducts: importedSessionData["products"],
      );

      await historyRepository.importHistorySession(
        id: importedSessionData["session"].id,
        importedHistoryActions: importedSessionData["historyActions"],
      );

      addToStream(_sessionsBox!.values.toList());
    }
  }

  Future<void> exportSession({required String id}) async {
    final Session? exportedSession = findById(id);

    if (exportedSession != null) {
      await ExportService().exportSessionToJson(
        session: exportedSession,
        products: await productsRepository.exportProductsSession(id: id),
        historyActions: await historyRepository.exportHistorySession(id: id),
      );
    }
  }

  Future<void> importSessionFromHtmlTable({
    String? author,
    required String data,
  }) async {
    final Map<int, Product>? importedProductsData =
        await ImportService().importFromHtmlTable(data);

    if (importedProductsData != null) {
      final newSession = Session(
        id: const Uuid().v1(),
        startDate: DateTime.now(),
        author: author,
      );
      if (_sessionsBox!.length >= maxStoredSessions) {
        await deleteSession(_sessionsBox!.values.toList().first.id);
      }
      await _sessionsBox!.add(newSession);

      await productsRepository.importProductsSession(
        id: newSession.id,
        importedProducts: importedProductsData,
      );

      await historyRepository.importHistorySession(
        id: newSession.id,
        importedHistoryActions: [],
      );

      addToStream(_sessionsBox!.values.toList());
    }
  }

  Future<void> importSessionFromCsv({
    String? author,
    required Map<String, int?> csvStructure,
    required List<List<String>> importedCsvList,
  }) async {
    final Map<int, Product>? importedProductsData =
        await ImportService().importFromCsv(
      csvStructure: csvStructure,
      importedCsvList: importedCsvList,
    );

    if (importedProductsData != null) {
      final newSession = Session(
        id: const Uuid().v1(),
        startDate: DateTime.now(),
        author: author,
      );
      if (_sessionsBox!.length >= maxStoredSessions) {
        await deleteSession(_sessionsBox!.values.toList().first.id);
      }
      await _sessionsBox!.add(newSession);

      await productsRepository.importProductsSession(
        id: newSession.id,
        importedProducts: importedProductsData,
      );

      await historyRepository.importHistorySession(
        id: newSession.id,
        importedHistoryActions: [],
      );

      addToStream(_sessionsBox!.values.toList());
    }
  }
}
