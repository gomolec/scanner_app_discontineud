import 'package:flutter/material.dart';
import 'package:scanner_app/constants.dart';
import 'package:scanner_app/models/history_action_model.dart';

class HistoryActionTile extends StatelessWidget {
  final HistoryAction historyAction;
  const HistoryActionTile({
    Key? key,
    required this.historyAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? title;
    Widget? subtitle;
    Widget? trailing;
    if (historyAction.oldProduct != null &&
        historyAction.updatedProduct == null) {
      //deleted
      title = Text("Usunięto ${historyAction.oldProduct!.name}");
      subtitle = Text(
        "${historyAction.oldProduct!.actualStock}/${historyAction.oldProduct!.previousStock}",
        style: const TextStyle(
          decoration: TextDecoration.lineThrough,
        ),
      );
      trailing = const Icon(
        Icons.delete_outline_rounded,
        color: redColor,
      );
    } else if (historyAction.oldProduct == null &&
        historyAction.updatedProduct != null) {
      //created
      title = Text("Dodano ${historyAction.updatedProduct!.name}");
      subtitle = Text(
        "${historyAction.updatedProduct!.actualStock}/${historyAction.updatedProduct!.previousStock}",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      );
      trailing = const Icon(
        Icons.add_circle_outline_rounded,
        color: greenColor,
      );
    } else if (historyAction.oldProduct != null &&
        historyAction.updatedProduct != null) {
      //updated
      title = Text("Zaaktualizowano ${historyAction.oldProduct!.name}");
      subtitle = Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text:
                  "${historyAction.oldProduct!.actualStock}/${historyAction.oldProduct!.previousStock}",
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const TextSpan(
              text: " ➔ ",
            ),
            TextSpan(
              text:
                  "${historyAction.updatedProduct!.actualStock}/${historyAction.updatedProduct!.previousStock}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
      String trailingText =
          "${historyAction.updatedProduct!.actualStock - historyAction.oldProduct!.actualStock}";
      if (int.parse(trailingText) > 0) {
        trailingText = "+$trailingText";
      }
      trailing = Text(
        trailingText,
        style:
            Theme.of(context).textTheme.headline6!.copyWith(color: greyColor),
      );
    }
    return ListTile(
      title: title,
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}
