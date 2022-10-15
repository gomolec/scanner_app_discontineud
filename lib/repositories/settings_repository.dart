import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';

class SettingsRepository {
  final HiveInterface hiveInterface;
  final _controller = BehaviorSubject<Map<String, dynamic>>();

  SettingsRepository({
    required this.hiveInterface,
  });

  Box<dynamic>? _settingsBox;

  Stream<Map<String, dynamic>> get settings => _controller.stream;

  void addToStream() {
    Map<dynamic, dynamic> settingsMap = _settingsBox!.toMap();
    Map<String, dynamic> formattedSettings = <String, dynamic>{};
    for (dynamic setting in settingsMap.keys) {
      formattedSettings[setting.toString()] = settingsMap[setting];
    }
    _controller.sink.add(formattedSettings);
  }

  void openSettingsSession() async {
    _settingsBox = await Hive.openBox("settings");
    await getDefaultSettings();
    addToStream();
  }

  Future<void> getDefaultSettings() async {
    String data = await rootBundle.loadString('assets/default_settings.json');
    Map<String, dynamic> defaultSettings = json.decode(data);
    for (String setting in defaultSettings.keys) {
      if (_settingsBox!.containsKey(setting) == false) {
        await setSetting(
          settingType: setting,
          settingValue: defaultSettings[setting],
        );
      }
    }
  }

  Future<void> setSetting({
    required String settingType,
    required dynamic settingValue,
  }) async {
    if (_settingsBox != null) {
      await _settingsBox!.put(settingType, settingValue);
      addToStream();
    }
  }

  dynamic getSetting(String settingType) {
    if (_settingsBox != null) {
      return _settingsBox!.get(settingType);
    }
    return null;
  }
}
