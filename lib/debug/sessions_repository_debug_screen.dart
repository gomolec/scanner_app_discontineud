import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
                      return ListTile(
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
                        onLongPress: () async {
                          await sessionsRepository
                              .deleteSession(snapshot.data![index].id);
                        },
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
          FloatingActionButton(
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
