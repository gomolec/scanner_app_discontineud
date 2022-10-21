import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/settings_cubit/settings_cubit.dart';

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
