import 'package:flutter/material.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
      icon: const Icon(Icons.history_rounded),
      tooltip: 'History',
    );
  }
}
