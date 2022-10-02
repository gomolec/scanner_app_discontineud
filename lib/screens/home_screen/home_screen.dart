import 'package:flutter/material.dart';
import 'package:scanner_app/screens/home_screen/pages/scanned_page.dart';
import 'package:scanner_app/screens/home_screen/pages/unscanned_page.dart';

import 'widgets/menu_drawer.dart';

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
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Search',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.history_rounded),
              tooltip: 'History',
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Niezeskanowane'),
              Tab(text: 'Zeskanowane'),
            ],
          ),
        ),
        drawer: const MenuDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Scan',
          child: const Icon(Icons.document_scanner_rounded),
        ),
        body: Column(
          children: const [
            Expanded(
              child: TabBarView(
                children: [
                  UnscannedPage(),
                  ScannedPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}