import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scanner_app/constants.dart';

import '../../../cubits/products_cubit/products_cubit.dart';
import '../../../cubits/sessions_cubit/sessions_cubit.dart';
import 'session_statisics_tile.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).viewPadding.top,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary,
            ),
            Material(
              elevation: 5.0,
              child: Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                alignment: Alignment.centerLeft,
                child: BlocBuilder<ProductsCubit, ProductsState>(
                  builder: (context, state) {
                    if (state is ProductsLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Statystyki sesji",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SessionStatisicsTile(
                            title: "Czas roczpoczęcia:",
                            subtitle: DateFormat("dd.MM.yyyyr. HH:mm").format(
                              context
                                  .read<SessionsCubit>()
                                  .actualSession!
                                  .startDate,
                            ),
                          ),
                          SessionStatisicsTile(
                            title: "Zeskanowane produkty:",
                            subtitle:
                                "${state.scannedProducts.length} / ${state.scannedProducts.length + state.unscannedProducts.length} rodzajów",
                          ),
                          SessionStatisicsTile(
                            title: "Proces skanowania:",
                            subtitle:
                                "${((state.scannedProducts.length * 100) / (state.scannedProducts.length + state.unscannedProducts.length)).round()} %",
                          ),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "ScannerApp",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          //TODO dodac nazwe uzytkownika
                          "nazwa użytkownika",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.history_rounded),
              title: const Text("Historia sesji"),
              onTap: () {
                Navigator.popAndPushNamed(context, "/sessions_history");
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_rounded),
              title: const Text("Import"),
              onTap: () {
                //Navigator.popAndPushNamed(context, "/sessions_history");
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text("Ustawienia"),
              onTap: () {
                //Navigator.popAndPushNamed(context, "/sessions_history");
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_repair_service_rounded),
              title: const Text("DEBUG"),
              onTap: () {
                Navigator.popAndPushNamed(context, "/debug");
              },
            ),
            const Spacer(),
            BlocBuilder<SessionsCubit, SessionsState>(
              builder: (context, state) {
                if (state is SessionsLoaded && state.actualSession == null) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<SessionsCubit>().createNewSession();
                      },
                      icon: const Icon(Icons.create_new_folder_rounded),
                      label: const Text("Utwórz nową sesję"),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<SessionsCubit>().endSession();
                      },
                      icon: const Icon(Icons.close_rounded),
                      label: const Text("Zakończ aktualną sesję"),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(redColor),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
