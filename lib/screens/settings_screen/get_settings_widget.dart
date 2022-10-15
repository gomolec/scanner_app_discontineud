import 'package:flutter/material.dart';

import 'widgets/author_tile.dart';

Widget getSettings({required String type, required dynamic value}) {
  switch (type) {
    case "author":
      return AuthorTile(value: value);
    default:
      return const SizedBox();
  }
}
