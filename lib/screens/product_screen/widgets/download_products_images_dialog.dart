import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants.dart';
import '../../../cubits/sessions_cubit/sessions_cubit.dart';

class DownloadProductsImagesDialog extends StatelessWidget {
  const DownloadProductsImagesDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Czy chcesz włączyć wyświetlanie zdjęć produktów?"),
      content: Text(
        "*Funkcja jest EKSPERYMENTALNA i działa tylko dla produktów sklepu KRUKAM.PL",
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(color: redColor.withOpacity(0.8)),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            context.read<SessionsCubit>().downloadSessionImages(value: false);
            Navigator.pop(context);
          },
          child: const Text('Nie'),
        ),
        TextButton(
          onPressed: () {
            context.read<SessionsCubit>().downloadSessionImages(value: true);
            Navigator.pop(context);
          },
          child: const Text('Tak'),
        ),
      ],
    );
  }
}
