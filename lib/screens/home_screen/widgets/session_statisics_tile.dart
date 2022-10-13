import 'package:flutter/material.dart';

class SessionStatisicsTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const SessionStatisicsTile({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
