import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository settingsRepository;
  late final StreamSubscription _subscription;

  SettingsCubit(
    this.settingsRepository,
  ) : super(SettingsInitial()) {
    _subscribe();
    settingsRepository.openSettingsSession();
  }

  Map<String, dynamic> settings = {};

  void _subscribe() {
    _subscription = settingsRepository.settings.listen(
      (items) {
        settings = items;
        emit(SettingsLoaded(settings: settings));
      },
      //TODO onError: (error) => emit(ListError('$error')),
    );
  }

  void setSetting({
    required String settingType,
    required dynamic settingValue,
  }) async {
    await settingsRepository.setSetting(
      settingType: settingType,
      settingValue: settingValue,
    );
  }

  dynamic getSetting(String settingType) {
    return settingsRepository.getSetting(settingType);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
