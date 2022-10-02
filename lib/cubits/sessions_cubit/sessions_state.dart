part of 'sessions_cubit.dart';

abstract class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object?> get props => [];
}

class SessionsInitial extends SessionsState {}

class SessionsLoaded extends SessionsState {
  final List<Session> sessions;
  final Session? actualSession;

  const SessionsLoaded({
    required this.sessions,
    this.actualSession,
  });

  SessionsLoaded copyWith({
    List<Session>? sessions,
    Session? actualSession,
  }) {
    return SessionsLoaded(
      sessions: sessions ?? this.sessions,
      actualSession: actualSession ?? this.actualSession,
    );
  }

  @override
  List<Object?> get props => [sessions, actualSession];
}
