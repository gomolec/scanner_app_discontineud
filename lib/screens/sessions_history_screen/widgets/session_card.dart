import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scanner_app/constants.dart';

import '../../../cubits/sessions_cubit/sessions_cubit.dart';
import '../../../models/models.dart';

class SessionCard extends StatelessWidget {
  final bool isActual;
  final Session session;

  const SessionCard({
    Key? key,
    this.isActual = false,
    required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 5.0,
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        shape: Border(
          right: BorderSide(
            width: 16,
            color: () {
              if (isActual == true) {
                return greenColor;
              }
              if (session.endDate == null) {
                return yellowColor;
              } else {
                return greyColor;
              }
            }(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
          child: Column(
            children: [
              ListTile(
                title: Text(() {
                  if (isActual == true) {
                    return "Aktualna sesja";
                  }
                  if (session.endDate == null) {
                    return "Niezakończona sesja";
                  } else {
                    return "Zakończona sesja";
                  }
                }()),
                subtitle: Text(() {
                  if (session.endDate != null) {
                    return "Utworzona ${DateFormat("HH:mm dd/MM/yyyy").format(session.startDate)}"
                        "\nZakończona ${DateFormat("HH:mm dd/MM/yyyy").format(session.endDate!)}"
                        "\nAutor ${session.author ?? "nieznany"}";
                  }
                  return "Utworzona ${DateFormat("HH:mm dd/MM/yyyy").format(session.startDate)}"
                      "\nAutor ${session.author ?? "nieznany"}";
                }()),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TextButton(
                      onPressed: () {
                        //TODO dodać możliwość eksportu
                      },
                      child: const Text("Eksportuj"),
                    ),
                  ),
                  const Spacer(),
                  isActual
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextButton(
                            onPressed: () {
                              context
                                  .read<SessionsCubit>()
                                  .restoreSession(id: session.id);
                            },
                            child: const Text("Przywróć"),
                          ),
                        ),
                  const SizedBox(width: 16.0),
                  isActual
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextButton(
                            onPressed: () {
                              context.read<SessionsCubit>().endSession();
                            },
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(redColor),
                            ),
                            child: const Text("Zakończ"),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextButton(
                            onPressed: () {
                              context
                                  .read<SessionsCubit>()
                                  .deleteSession(id: session.id);
                            },
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(redColor),
                            ),
                            child: const Text("Usuń"),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
