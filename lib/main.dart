import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:scanner_app/models/models.dart';
import 'repositories/sessions_repository.dart';
import 'repositories/history_repository.dart';
import 'repositories/products_repository.dart';

import 'test/sessions_repository_test_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(HistoryActionAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
    return MaterialApp(
      title: 'Scanner App Demo',
      home: SessionsRepositoryTestScreen(
        sessionsRepository: sessionsRepository,
        productsRepository: productsRepository,
        historyRepository: historyRepository,
      ),
    );
  }
}
