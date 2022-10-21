import 'package:flutter/material.dart';
import 'author_alert_dialog.dart';

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
