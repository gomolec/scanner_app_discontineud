import 'package:flutter/material.dart';
import 'package:scanner_app/services/import_service.dart';

class CsvImportProvider extends ChangeNotifier {
  List<List<String>>? importedCsvList;
  Map<String, int?> csvStructure = {
    "name": null,
    "code": null,
    "previousStock": null,
    "actualStock": null,
  };
  bool isFirstRowData = false;

  updateCsvStructure({
    required String key,
    required int value,
  }) {
    csvStructure[key] = value;
    notifyListeners();
  }

  Future<List<List<String>>?> getimportedCsvList() async {
    importedCsvList = await ImportService().getCsvFileStructure();
    notifyListeners();
    return importedCsvList;
  }

  updateIsFirstRowData(bool value) {
    isFirstRowData = value;
    notifyListeners();
  }
}
