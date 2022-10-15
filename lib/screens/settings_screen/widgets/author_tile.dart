import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubits/settings_cubit/settings_cubit.dart';

class AuthorTile extends StatelessWidget {
  final String? value;
  const AuthorTile({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: const Text("Nazwa autora sesji"),
        subtitle: Text(value.toString()),
        trailing: const Icon(Icons.keyboard_arrow_right_rounded),
        onTap: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AuthorAlertDialog(value: value);
          },
        ),
      ),
    );
  }
}

class AuthorAlertDialog extends StatelessWidget {
  const AuthorAlertDialog({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String? value;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: value);
    return AlertDialog(
      title: const Text('Nazwa autora sesji'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              'Każda nowo utworzona sesja ma przypisanego autora, ułatwia to póżniejsze zarządzanie sesjami.'),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Autor',
              hintText: 'Nazwa autora sesji',
            ),
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
            context.read<SettingsCubit>().setSetting(
                  settingType: "author",
                  settingValue: controller.text,
                );
            Navigator.pop(context);
          },
          child: const Text('Zapisz'),
        ),
      ],
    );
  }
}
