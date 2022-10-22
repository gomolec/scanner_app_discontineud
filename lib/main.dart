import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '/models/models.dart';
import '/providers/quantity_provider.dart';
import 'cubits/history_cubit/history_cubit.dart';
import 'cubits/products_cubit/products_cubit.dart';
import 'cubits/sessions_cubit/sessions_cubit.dart';
import 'cubits/settings_cubit/settings_cubit.dart';
import 'globals.dart';
import 'providers/search_bar_provider.dart';
import 'repositories/sessions_repository.dart';
import 'repositories/history_repository.dart';
import 'repositories/products_repository.dart';
import 'repositories/settings_repository.dart';

import 'package:json_theme/json_theme.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'debug/sessions_repository_debug_screen.dart';
import 'screens/import_screen/import_screen.dart';
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
  late final SettingsRepository settingsRepository = SettingsRepository(
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
          create: (context) => SettingsCubit(settingsRepository),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SessionsCubit(
            sessionsRepository: sessionsRepository,
            settingsRepository: settingsRepository,
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => ProductsCubit(
            productsRepository: productsRepository,
            historyRepository: historyRepository,
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => HistoryCubit(
            historyRepository: historyRepository,
            productsRepository: productsRepository,
          ),
          lazy: false,
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
          scaffoldMessengerKey: snackbarKey,
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/product': (context) => const ProductScreen(),
            '/sessions_history': (context) => const SessionsHistoryScreen(),
            '/scanner': (context) => ScannerScreen(),
            '/import': (context) => const ImportScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/debug': (context) => const SessionsRepositoryDebugScreen(),
          },
        ),
      ),
    );
  }
}
