import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scanner_app/models/models.dart';
import '../globals.dart';

class ExportService {
  Future<void> exportSessionToJson({
    required Session session,
    required Map<int, Product> products,
    required List<HistoryAction> historyActions,
  }) async {
    try {
      Map<String, Product> convertedProducts = {};
      products.forEach((key, value) {
        convertedProducts.putIfAbsent(key.toString(), () => value);
      });

      final Map exportedData = {
        "session": session,
        "products": convertedProducts,
        "historyActions": historyActions
      };

      final String jsonData = jsonEncode(exportedData);

      String? fileDirectory = await FilePicker.platform.getDirectoryPath();
      if (fileDirectory == null) {
        throw "Operacja anulowana przez użytkownika.";
      }

      final String fileName =
          'session_${DateFormat("ddMMyyyyHHmm").format(session.startDate)}.json';

      File jsonFile = File("$fileDirectory/$fileName");
      await jsonFile.writeAsString(jsonData);

      snackbarKey.currentState?.showSnackBar(
        SnackBar(content: Text("Utworzono plik o nazwie \"$fileName\".")),
      );
    } catch (e) {
      //TODO to powinno wyrzucać tylko błędy, które łapane powinny być w cubicie, jak i wyświetlanie snackbara
      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Wystąpił błąd podczas zapisywania pliku.\n$e"),
        ),
      );
    }
  }
}
