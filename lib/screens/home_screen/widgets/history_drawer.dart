import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/history_cubit/history_cubit.dart';
import 'history_action_tile.dart';

class HistoryDrawer extends StatelessWidget {
  const HistoryDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Material(
              elevation: 5.0,
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top,
                  left: 16,
                ),
                height: kToolbarHeight + MediaQuery.of(context).viewPadding.top,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Historia zmian",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.history.length,
                            itemBuilder: (context, index) {
                              return HistoryActionTile(
                                historyAction: state.history[index],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: (state.canUndo)
                                    ? () {
                                        context.read<HistoryCubit>().undo();
                                      }
                                    : null,
                                icon: const Icon(Icons.undo_rounded),
                                label: const Text("Cofnij"),
                              ),
                              ElevatedButton.icon(
                                onPressed: (state.canRedo)
                                    ? () {
                                        context.read<HistoryCubit>().redo();
                                      }
                                    : null,
                                icon: const Icon(Icons.redo_rounded),
                                label: const Text("Ponów"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Brak rozpoczętej sesji",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
