import 'package:flutter/material.dart';
import 'package:scanner_app/screens/import_screen/widgets/import_from_html_alert_dialog.dart';

import 'widgets/import_from_csv_structure_alert_dialog.dart';

class ImportScreen extends StatelessWidget {
  const ImportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Importowanie"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return const ImportFromHtmlAlertDialog();
                  },
                );
              },
              child: const Text("Importowanie skopiowanej tabeli HTML"),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return const ImportFromCsvStructureAlert();
                  },
                );
              },
              child: const Text("Importowanie pliku CSV"),
            )
          ],
        ),
      ),
    );
  }
}
