import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/sessions_cubit/sessions_cubit.dart';
import '../../../globals.dart';

class ImportFromHtmlAlertDialog extends StatelessWidget {
  const ImportFromHtmlAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    String? importedData;
    return AlertDialog(
      title: const Text('Importowanie skopiowanej tabeli HTML'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            minLines: 10,
            maxLines: 10,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Skopiowany tekst',
              hintText: 'Tutaj wyświetli się wklejony tekst',
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final clipboardData =
                  await Clipboard.getData(Clipboard.kTextPlain);
              if (clipboardData != null &&
                  clipboardData.text != null &&
                  clipboardData.text!.isNotEmpty) {
                importedData = clipboardData.text!;
                controller.text = importedData!;
              } else {
                snackbarKey.currentState?.showSnackBar(
                  const SnackBar(
                    content: Text("Brak danych do skopiowania"),
                  ),
                );
              }
            },
            child: const Text("Wklej tekst"),
          ),
          const SizedBox(height: 8),
          Text(
            '*Importowanie działa jedynie z danymi skopiowanymi ze strony panelu kontrolnego Krukam.pl',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Anuluj'),
        ),
        TextButton(
          onPressed: () {
            if (importedData != null) {
              context
                  .read<SessionsCubit>()
                  .importSessionFromHtmlTable(importedData!);
              snackbarKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text(
                    "Zaimportowano pomyślnie",
                  ),
                ),
              );
              Navigator.pop(context);
            } else {
              snackbarKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text(
                    "Brak danych zaimportowana.\nSpróbuj najpierw wkleić dane.",
                  ),
                ),
              );
            }
          },
          child: const Text('Importuj'),
        ),
      ],
    );
  }
}
