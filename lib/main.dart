import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:scanner_app/models/models.dart';
import 'repositories/sessions_repository.dart';
import 'repositories/history_repository.dart';
import 'repositories/products_repository.dart';

import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'debug/sessions_repository_debug_screen.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeStr = await rootBundle.loadString('assets/theme/light_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  await Hive.initFlutter();
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(HistoryActionAdapter());

  runApp(MyApp(
    theme: theme,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({
    required this.theme,
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
    return MaterialApp(
      theme: theme,
      title: 'Scanner App',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/product': (context) => const ProductScreen(),
        '/debug': (context) => SessionsRepositoryDebugScreen(
              sessionsRepository: sessionsRepository,
              productsRepository: productsRepository,
              historyRepository: historyRepository,
            ),
      },
    );
  }
}
