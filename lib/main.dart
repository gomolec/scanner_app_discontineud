import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scanner_app/screens/scanner_screen/scanner_screen.dart';

import '/models/models.dart';
import '/providers/quantity_provider.dart';
import 'cubits/history_cubit/history_cubit.dart';
import 'cubits/products_cubit/products_cubit.dart';
import 'cubits/sessions_cubit/sessions_cubit.dart';
import 'providers/search_bar_provider.dart';
import 'repositories/sessions_repository.dart';
import 'repositories/history_repository.dart';
import 'repositories/products_repository.dart';

import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'debug/sessions_repository_debug_screen.dart';
import 'screens/screens.dart';
import 'screens/sessions_history_screen/sessions_history_screen.dart';

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

  MyApp({
    required this.theme,
    Key? key,
  }) : super(key: key);

  final HiveInterface hiveInterface = Hive;
  late final ProductsRepository productsRepository = ProductsRepository(
    hiveInterface: hiveInterface,
  );
  late final HistoryRepository historyRepository = HistoryRepository(
    hiveInterface: hiveInterface,
  );
  late final SessionsRepository sessionsRepository = SessionsRepository(
    hiveInterface: hiveInterface,
    productsRepository: productsRepository,
    historyRepository: historyRepository,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SessionsCubit(
            sessionsRepository: sessionsRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ProductsCubit(
            productsRepository: productsRepository,
            historyRepository: historyRepository,
          ),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(
            historyRepository: historyRepository,
            productsRepository: productsRepository,
          ),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => QuantityProvider()),
          ChangeNotifierProvider(create: (context) => SearchBarProvider()),
        ],
        child: MaterialApp(
          theme: theme,
          title: 'Scanner App',
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/product': (context) => const ProductScreen(),
            '/sessions_history': (context) => const SessionsHistoryScreen(),
            '/scanner': (context) => ScannerScreen(),
            '/debug': (context) => const SessionsRepositoryDebugScreen(),
          },
        ),
      ),
    );
  }
}
