import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:scanner_app/providers/csv_import_provider.dart';

import '../../../cubits/sessions_cubit/sessions_cubit.dart';
import '../../../globals.dart';

class ImportFromCsvStructureAlert extends StatelessWidget {
  const ImportFromCsvStructureAlert({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return ChangeNotifierProvider(
      create: (context) => CsvImportProvider(),
      builder: (context, widget) {
        return AlertDialog(
          title: const Text('Importowanie pliku CSV'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Selector<CsvImportProvider, List<List<String>>?>(
                selector: (context, csvImportProvider) =>
                    csvImportProvider.importedCsvList,
                builder: (_, importedCsvList, __) {
                  if (importedCsvList == null) {
                    return Column(
                      children: [
                        Text(
                          'Plik CSV (wartości rozdzielone przecinkami) to specjalny typ pliku, który można tworzyć i edytować w programie Excel.',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final navigator = Navigator.of(context);
                            var data = await context
                                .read<CsvImportProvider>()
                                .getimportedCsvList();
                            if (data == null) {
                              navigator.pop();
                            }
                          },
                          child: const Text("Wybierz plik"),
                        ),
                      ],
                    );
                  } else {
                    return Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text(
                            'Pliki CSV mogą różnić się od siebie budową. Przyporządkuj odpowiednie kolumny pliku do rodzaju danych w nich zawartych.',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          const SizedBox(height: 16),
                          const CsvImportDropdownButton(
                            title: "Nazwa produktu",
                            dataColumn: "name",
                          ),
                          const SizedBox(height: 16),
                          const CsvImportDropdownButton(
                            title: "Kod produktu",
                            dataColumn: "code",
                          ),
                          const SizedBox(height: 16),
                          const CsvImportDropdownButton(
                            title: "Poprzedni stan",
                            dataColumn: "previousStock",
                          ),
                          const SizedBox(height: 16),
                          const CsvImportDropdownButton(
                            title: "Aktualny stan",
                            dataColumn: "actualStock",
                            isRequired: false,
                          ),
                          const SizedBox(height: 16),
                          const CsvImportFirstRowCheckbox(),
                        ],
                      ),
                    );
                  }
                },
              ),
              // Text(
              //   'Pliki CSV mogą różnić się od siebie budową. Przyporządkuj odpowiednie kolumny pliku do rodzaju danych w nich zawartych.',
              //   style: Theme.of(context).textTheme.caption,
              // ),
              // const SizedBox(height: 8),
              // CsvImportDropdownButton(list: list),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj'),
            ),
            Selector<CsvImportProvider, List<List<String>>?>(
              selector: (context, csvImportProvider) =>
                  csvImportProvider.importedCsvList,
              builder: (_, importedCsvList, __) => importedCsvList != null
                  ? TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<SessionsCubit>().importSessionFromCsv(
                                csvStructure: context
                                    .read<CsvImportProvider>()
                                    .csvStructure,
                                importedCsvList: context
                                    .read<CsvImportProvider>()
                                    .importedCsvList!,
                              );
                          snackbarKey.currentState?.showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Zaimportowano pomyślnie",
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Importuj'),
                    )
                  : const SizedBox(),
            ),
          ],
        );
      },
    );
  }
}

class CsvImportFirstRowCheckbox extends StatelessWidget {
  const CsvImportFirstRowCheckbox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Selector<CsvImportProvider, bool>(
              selector: (context, csvImportProvider) =>
                  csvImportProvider.isFirstRowData,
              builder: (context, value, child) => Checkbox(
                value: !value,
                onChanged: (value) {
                  context.read<CsvImportProvider>().updateIsFirstRowData();
                },
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Pierwszy wiersz to nagłówki",
              style: Theme.of(context).textTheme.bodyText2,
            )
          ],
        ),
        Text(
          'Zaznacz w przypadku, gdy w pierwszym wierszu pliku znajdują się nagłównki (nazwy kolumn).',
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

class CsvImportDropdownButton extends StatelessWidget {
  final String title;
  final String dataColumn;
  final bool isRequired;

  const CsvImportDropdownButton({
    Key? key,
    required this.title,
    required this.dataColumn,
    this.isRequired = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<CsvImportProvider, int?>(
      selector: (context, csvImportProvider) =>
          csvImportProvider.csvStructure[dataColumn],
      builder: (context, value, child) {
        List<String> csvColumns =
            context.read<CsvImportProvider>().importedCsvList![0];
        return DropdownButtonFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: title,
            helperText: isRequired ? "*Pole wymagane" : null,
          ),
          value: value,
          items:
              csvColumns.asMap().keys.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(csvColumns[value]),
            );
          }).toList(),
          onChanged: (int? value) {
            if (value != null) {
              context
                  .read<CsvImportProvider>()
                  .updateCsvStructure(key: dataColumn, value: value);
            }
          },
          isExpanded: true,
          validator: (int? value) {
            if (value == null && isRequired == true) {
              return 'Wybierz odpowiednią kolumnę';
            }
            return null;
          },
        );
      },
    );
  }
}
