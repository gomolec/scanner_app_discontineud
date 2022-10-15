import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubits/settings_cubit/settings_cubit.dart';

import 'get_settings_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ustawienia"),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            final List<String> settingsTypes = state.settings.keys.toList();
            final List<dynamic> settingsValues = state.settings.values.toList();
            return ListView.separated(
              itemCount: state.settings.length,
              itemBuilder: (context, index) {
                return getSettings(
                  type: settingsTypes[index],
                  value: settingsValues[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  thickness: 2,
                  height: 8,
                  indent: 8,
                  endIndent: 8,
                );
              },
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Błąd podczas ładowania ustawień",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
