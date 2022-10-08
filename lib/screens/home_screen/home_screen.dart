import 'package:flutter/material.dart';
import 'package:scanner_app/screens/home_screen/pages/scanned_page.dart';
import 'package:scanner_app/screens/home_screen/pages/unscanned_page.dart';
import 'package:scanner_app/screens/home_screen/widgets/history_drawer.dart';

import 'widgets/history_button.dart';
import 'widgets/menu_drawer.dart';
import 'widgets/scan_floating_button.dart';
import 'widgets/search_bar.dart';
import 'widgets/search_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Scanner App"),
          centerTitle: true,
          actions: const [
            SearchButton(),
            HistoryButton(),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Niezeskanowane'),
              Tab(text: 'Zeskanowane'),
            ],
          ),
        ),
        endDrawer: const HistoryDrawer(),
        drawer: const MenuDrawer(),
        floatingActionButton: const ScanFloatingButton(),
        body: Column(
          children: [
            const Expanded(
              child: TabBarView(
                children: [
                  UnscannedPage(),
                  ScannedPage(),
                ],
              ),
            ),
            SearchBar(),
          ],
        ),
      ),
    );
  }
}
