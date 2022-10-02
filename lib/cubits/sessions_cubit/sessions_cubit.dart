import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/models/models.dart';
import '../../repositories/sessions_repository.dart';

part 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final SessionsRepository sessionsRepository;
  late final StreamSubscription _subscription;

  SessionsCubit({
    required this.sessionsRepository,
  }) : super(SessionsInitial()) {
    _subscribe();
    sessionsRepository.getSavedSessions();
  }

  List<Session> sessions = [];
  Session? actualSession;
  String? author;

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
    actualSession = await sessionsRepository.createNewSession(author: author);
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

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
