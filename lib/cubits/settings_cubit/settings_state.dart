part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Map<String, dynamic> settings;

  const SettingsLoaded({
    required this.settings,
  });

  @override
  List<Object> get props => [settings];
}
