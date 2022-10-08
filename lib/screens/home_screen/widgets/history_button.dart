import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/history_cubit/history_cubit.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return IconButton(
          onPressed: state is HistoryLoaded
              ? () {
                  Scaffold.of(context).openEndDrawer();
                }
              : null,
          icon: const Icon(Icons.history_rounded),
          tooltip: 'History',
        );
      },
    );
  }
}
