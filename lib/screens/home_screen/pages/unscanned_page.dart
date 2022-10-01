import 'package:flutter/material.dart';

import 'package:scanner_app/models/models.dart';

import '../widgets/product_tile.dart';

class UnscannedPage extends StatelessWidget {
  const UnscannedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ProductTile(
          product: Product(
            name: "name",
            code: "code",
            previousStock: 5,
          ),
        ),
        ProductTile(
          product: Product(
              name: "name",
              code: "code",
              actualStock: 10,
              previousStock: 10,
              isPinned: true),
        ),
        ProductTile(
          product: Product(
            name: "name",
            code: "code",
            actualStock: 12,
            previousStock: 5,
          ),
        ),
        ProductTile(
          product: Product(
            name: "name",
            code: "code",
            actualStock: 17,
            previousStock: 20,
          ),
        ),
      ],
    );
  }
}
