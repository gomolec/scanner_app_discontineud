import 'package:flutter/material.dart';
import 'package:scanner_app/constants.dart';

import '../../../models/models.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.code),
      leading: product.isPinned
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.flag_rounded,
                  color: redColor,
                ),
              ],
            )
          : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.subtitle1,
              children: [
                TextSpan(
                  text: "${product.actualStock}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: () {
                      if (product.actualStock == product.previousStock) {
                        return greenColor;
                      } else if (product.actualStock > product.previousStock) {
                        return redColor;
                      } else if (product.actualStock == 0) {
                        return greyColor;
                      } else if (product.actualStock < product.previousStock) {
                        return yellowColor;
                      }
                    }(),
                  ),
                ),
                const TextSpan(text: " / "),
                TextSpan(
                  text: "${product.previousStock}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, '/product', arguments: product);
      },
    );
  }
}
