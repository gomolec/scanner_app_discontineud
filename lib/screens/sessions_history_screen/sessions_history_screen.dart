import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubits/sessions_cubit/sessions_cubit.dart';
import 'package:scanner_app/screens/sessions_history_screen/widgets/session_card.dart';

class SessionsHistoryScreen extends StatelessWidget {
  const SessionsHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historia sesji"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "import_floating_button",
            onPressed: () {
              context.read<SessionsCubit>().importSessionFromJson();
            },
            tooltip: 'Import session',
            child: const Icon(Icons.download_rounded),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: "create_floating_button",
            onPressed: () {
              context.read<SessionsCubit>().createNewSession();
              Navigator.pop(context);
            },
            tooltip: 'Create session',
            child: const Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      body: BlocBuilder<SessionsCubit, SessionsState>(
        builder: (context, state) {
          if (state is SessionsLoaded && state.sessions.isNotEmpty) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  state.actualSession != null
                      ? Column(
                          children: [
                            SessionCard(
                              isActual: true,
                              session: state.actualSession!,
                            ),
                            const Divider(
                              thickness: 2,
                              height: 8,
                              indent: 8,
                              endIndent: 8,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  ListView.builder(
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.sessions.length,
                    itemBuilder: (context, index) {
                      if (state.actualSession != null &&
                          state.sessions[index].id == state.actualSession?.id) {
                        return const SizedBox();
                      }
                      return SessionCard(
                        session: state.sessions[index],
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Brak zapisanych poprzednich sesji.\nUtwórz nową sesję i zacznij skanować!",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<SessionsCubit>().createNewSession();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.create_new_folder_rounded),
                      label: const Text("Utwórz nową sesję"),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
