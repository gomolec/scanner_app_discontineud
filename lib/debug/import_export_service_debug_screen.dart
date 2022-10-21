import 'package:flutter/material.dart';
import 'package:scanner_app/models/models.dart';
import 'package:scanner_app/services/export_service.dart';

import '../services/import_service.dart';

class ImportExportServiceDebugScreen extends StatelessWidget {
  ImportExportServiceDebugScreen({Key? key}) : super(key: key);

  final Session testSession =
      Session(id: "test", author: "Tester", startDate: DateTime.now());
  final Map<int, Product> testProducts = {
    1: const Product(id: 1, name: "Product1", code: "0001", previousStock: 10),
    2: const Product(id: 2, name: "Product2", code: "0002", previousStock: 20),
    3: const Product(id: 3, name: "Product3", code: "0003", previousStock: 30),
  };
  final List<HistoryAction> testHistoryActions = [
    const HistoryAction(id: 1),
    const HistoryAction(id: 2),
    const HistoryAction(id: 3),
  ];
  final ExportService exportService = ExportService();
  final ImportService importService = ImportService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ExportServiceDebugScreen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                exportService.exportSessionToJson(
                  session: testSession,
                  products: testProducts,
                  historyActions: testHistoryActions,
                );
              },
              child: const Text("Test Export"),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await importService.importSessionFromJson();
              },
              child: const Text("Test Import"),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final String importedData = await DefaultAssetBundle.of(context)
                    .loadString('assets/html_table.txt');

                await importService.importFromHtmlTable(importedData);
              },
              child: const Text("Test Import From HTML Table"),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                exportService.exportToCsv(
                  session: testSession,
                  products: testProducts,
                );
              },
              child: const Text("Test Export To CSV"),
            ),
          ),
        ],
      ),
    );
  }
}
