import 'package:flutter/material.dart';

import '../models/models.dart';
import '../repositories/sessions_repository.dart';

class SessionsRepositoryTestScreen extends StatelessWidget {
  final SessionRepository sessionRepository;
  const SessionsRepositoryTestScreen({
    Key? key,
    required this.sessionRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sessions Repository Test")),
      body: Column(
        children: [
          StreamBuilder(
            stream: sessionRepository.sessions,
            builder:
                (BuildContext context, AsyncSnapshot<List<Session>> snapshot) {
              sessionRepository.getSavedSessions();
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].id),
                      subtitle: Text((() {
                        String subtitle =
                            snapshot.data![index].startDate.toString();
                        if (snapshot.data![index].endDate != null) {
                          subtitle += "\n${snapshot.data![index].endDate}";
                        }
                        return subtitle;
                      }())),
                      onLongPress: () {
                        sessionRepository.endSession(snapshot.data![index].id);
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              sessionRepository.createNewSession(author: 'TEST');
            },
          )
        ],
      ),
    );
  }
}
