import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scanner_app/debug/import_export_service_debug_screen.dart';

import 'products_repository_debug_screen.dart';

import '../models/models.dart';
import '../repositories/products_repository.dart';
import '../repositories/sessions_repository.dart';
import '../repositories/history_repository.dart';

class SessionsRepositoryDebugScreen extends StatelessWidget {
  const SessionsRepositoryDebugScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HiveInterface hiveInterface = Hive;
    final ProductsRepository productsRepository = ProductsRepository(
      hiveInterface: hiveInterface,
    );
    final HistoryRepository historyRepository = HistoryRepository(
      hiveInterface: hiveInterface,
    );
    final SessionsRepository sessionsRepository = SessionsRepository(
      hiveInterface: hiveInterface,
      productsRepository: productsRepository,
      historyRepository: historyRepository,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sessions Repository Test"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: sessionsRepository.sessions,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Session>> snapshot) {
                sessionsRepository.getSavedSessions();
                if (snapshot.hasData) {
                  return ListView.builder(
                    //reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key('item ${snapshot.data![index].id}'),
                        confirmDismiss: (DismissDirection direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            await sessionsRepository.exportSession(
                                id: snapshot.data![index].id);
                          } else if (direction == DismissDirection.endToStart) {
                            await sessionsRepository
                                .deleteSession(snapshot.data![index].id);
                            return true;
                          }
                          return false;
                        },
                        background: Container(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: const [
                                Icon(Icons.download_rounded,
                                    color: Colors.white),
                                Text(
                                  'Eksportuj',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(Icons.delete, color: Colors.white),
                                Text(
                                  'Usuń',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Text("${index + 1}."),
                          title: Text(snapshot.data![index].id),
                          subtitle: Text((() {
                            String subtitle =
                                snapshot.data![index].startDate.toString();
                            if (snapshot.data![index].endDate != null) {
                              subtitle += "\n${snapshot.data![index].endDate}";
                            }
                            return subtitle;
                          }())),
                          onTap: () {
                            productsRepository
                                .openProductsSession(snapshot.data![index].id);
                            historyRepository
                                .openHistorySession(snapshot.data![index].id);
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    ProductsRepositoryDebugScreen(
                                  productsRepository: productsRepository,
                                  historyRepository: historyRepository,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onLongPress: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      ImportExportServiceDebugScreen(),
                ),
              );
            },
            child: FloatingActionButton(
              heroTag: "btn1",
              child: const Icon(Icons.download_rounded),
              onPressed: () async {
                await sessionsRepository.importSession();
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            child: const Icon(Icons.add),
            onPressed: () async {
              await sessionsRepository.createNewSession(author: 'TEST');
            },
          )
        ],
      ),
    );
  }
}
