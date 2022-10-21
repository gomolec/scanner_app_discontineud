import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../models/models.dart';

class ImportService {
  Future<Map?> importSessionFromJson() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

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

  Future<Map<int, Product>?> importFromHtmlTable(String data) async {
    try {
      List<String> importedData = data.split("\n");

      if (importedData[0].split("\t").length < 8 ||
          (importedData.length - 1) % 2 != 0) {
        throw "Niepoprawne dane wejściowe. Sprawdz zgodność skopiowanych danych";
      }

      Map<int, Product> importedProducts = {};
      for (var i = 1; i < importedData.length; i += 2) {
        final List formatedData =
            importedData[i].split('\t') + importedData[i + 1].split('\t');
        importedProducts.putIfAbsent(
          int.parse(formatedData[0]),
          () => Product(
            id: int.parse(formatedData[0]),
            name: formatedData[3],
            code: formatedData[2],
            previousStock: int.parse((formatedData[5] as String).split(" ")[0]),
          ),
        );
      }
      return importedProducts;
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Wystąpił błąd podczas importowania sesji.\n$e"),
        ),
      );
    }
    return null;
  }

  Future<List<List<String>>?> getCsvFileStructure() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null) {
        throw "Anulowanie operacji przez użytkownika.";
      }

      File file = File(result.files.single.path.toString());

      String importedData = await file.readAsString();

      List<List<String>> importedCsvList = const CsvToListConverter().convert(
        importedData,
        shouldParseNumbers: false,
      );

      return importedCsvList;
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Wystąpił błąd podczas importowania sesji.\n$e"),
        ),
      );
    }
    return null;
  }

  Future<Map<int, Product>?> importFromCsv({
    required Map<String, int?> csvStructure,
    required List<List<String>> importedCsvList,
    bool isFirstRowData = false,
  }) async {
    try {
      int nameIndex = csvStructure["name"]!;
      int codeIndex = csvStructure["code"]!;
      int previousStockIndex = csvStructure["previousStock"]!;
      int? actualStockIndex = csvStructure["actualStock"];

      Map<int, Product> importedProducts = {};
      int id = 0;

      if (!isFirstRowData) {
        importedCsvList.removeAt(0);
      }

      for (var item in importedCsvList) {
        importedProducts.putIfAbsent(
          id,
          () => Product(
            name: item[nameIndex],
            code: item[codeIndex],
            previousStock: int.parse(item[previousStockIndex]),
            actualStock: actualStockIndex != null
                ? int.parse(item[actualStockIndex])
                : 0,
          ),
        );
        id++;
      }
      return importedProducts;
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
