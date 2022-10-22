import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scanner_app/models/models.dart';

import '../../repositories/sessions_repository.dart';
import '../../repositories/settings_repository.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepository sessionsRepository;
  final SettingsRepository settingsRepository;
  late final StreamSubscription _subscription;

  SessionsCubit({
    required this.sessionsRepository,
    required this.settingsRepository,
  }) : super(SessionsInitial()) {
    _subscribe();
    sessionsRepository.getSavedSessions();
  }

  List<Session> sessions = [];
  Session? actualSession;

  void _subscribe() {
    _subscription = sessionsRepository.sessions.listen(
      (items) {
        sessions = items;
        emit(SessionsLoaded(
          sessions: sessions,
          actualSession: actualSession,
        ));
      },
      //TODO onError: (error) => emit(ListError('$error')),
    );
  }

  void createNewSession() async {
    actualSession = await sessionsRepository.createNewSession(
        author: settingsRepository.getSetting("author"));
  }

  void restoreSession({required String id}) async {
    actualSession = await sessionsRepository.restoreSession(id);
    emit(SessionsLoaded(
      sessions: sessions,
      actualSession: actualSession,
    ));
  }

  void deleteSession({required String id}) async {
    //TODO sprawdzić czy działa dobrze - czy usuwa tez product&historySession
    if (actualSession != null && actualSession!.id == id) {
      actualSession = null;
    }
    await sessionsRepository.deleteSession(id);
  }

  void endSession() async {
    if (actualSession != null) {
      final String endedId = actualSession!.id;
      actualSession = null;
      sessionsRepository.endSession(endedId);
    }
  }

  void downloadSessionImages({String? id, required bool value}) async {
    if (id == null) {
      if (actualSession != null) {
        actualSession = sessionsRepository
            .findById(actualSession!.id)!
            .copyWith(downloadImages: () => value);
        await sessionsRepository.updateSession(actualSession!);
      }
    } else {
      await sessionsRepository.updateSession(
        sessionsRepository.findById(id)!.copyWith(downloadImages: () => value),
      );
    }
  }

  void importSessionFromJson() async {
    await sessionsRepository.importSessionFromJson();
  }

  void exportSessionToJson({required String id}) async {
    await sessionsRepository.exportSessionToJson(id: id);
  }

  void importSessionFromHtmlTable(String data) async {
    await sessionsRepository.importSessionFromHtmlTable(
      author: settingsRepository.getSetting("author"),
      data: data,
    );
  }

  void importSessionFromCsv({
    required Map<String, int?> csvStructure,
    required List<List<String>> importedCsvList,
  }) async {
    await sessionsRepository.importSessionFromCsv(
      author: settingsRepository.getSetting("author"),
      csvStructure: csvStructure,
      importedCsvList: importedCsvList,
    );
  }

  void exportSessionToCsv({required String id}) async {
    await sessionsRepository.exportSessionToCsv(id: id);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
