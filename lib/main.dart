import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:scanner_app/models/models.dart';
import 'package:scanner_app/repositories/sessions_repository.dart';

import 'test/sessions_repository_test_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SessionAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HiveInterface hiveInterface = Hive;
    final SessionRepository sessionRepository = SessionRepository(
      hiveInterface: hiveInterface,
    );
    return MaterialApp(
      title: 'Flutter Demo',
      home: SessionsRepositoryTestScreen(
        sessionRepository: sessionRepository,
      ),
    );
  }
}
