import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../models/models.dart';

class ImportService {
  Future<Map?> importSessionFromJson() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result == null) {
        throw "Anulowanie operacji przez użytkownika.";
      }
      File file = File(result.files.single.path.toString());

      Map importedData = jsonDecode(await file.readAsString());

      //Session
      importedData["session"] = Session.fromJson(importedData["session"]);

      //Products
      Map<int, Product> convertedProducts = {};
      (importedData["products"] as Map<String, dynamic>).forEach(
        (key, value) => convertedProducts.putIfAbsent(
          int.parse(key),
          () => Product.fromJson(value),
        ),
      );

      importedData["products"] = convertedProducts;

      //HistoryActions
      List<HistoryAction> importedHistoryActions = [];
      for (var historyAction in importedData["historyActions"]) {
        importedHistoryActions.add(HistoryAction.fromJson(historyAction));
      }
      importedData["historyActions"] = importedHistoryActions;

      snackbarKey.currentState?.showSnackBar(
        const SnackBar(content: Text("Pomyślnie zaimportowano sesję.")),
      );
      return importedData;
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Wystąpił błąd podczas importowania sesji.\n$e"),
        ),
      );
    }
    return null;
  }
}
